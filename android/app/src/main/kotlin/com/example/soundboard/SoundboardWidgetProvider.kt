package com.example.soundboard

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class SoundboardWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Get sound name from shared preferences
                val soundName = HomeWidgetPlugin.getData(context)
                    .getString("sound_name", "No Sound Selected")
                setTextViewText(R.id.widget_sound_name, soundName)
                
                // Update subtitle based on selection
                val subtitle = if (soundName == "No Sound Selected") {
                    "Configure in app"
                } else {
                    "Tap to play"
                }
                setTextViewText(R.id.widget_subtitle, subtitle)
                
                // Create intent to launch app when widget is tapped
                val intent = Intent(context, MainActivity::class.java).apply {
                    action = Intent.ACTION_VIEW
                    data = android.net.Uri.parse("soundboard://play")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    widgetId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                
                // Make entire widget clickable
                setOnClickPendingIntent(R.id.widget_icon, pendingIntent)
                setOnClickPendingIntent(R.id.widget_sound_name, pendingIntent)
                setOnClickPendingIntent(R.id.widget_subtitle, pendingIntent)
            }
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}