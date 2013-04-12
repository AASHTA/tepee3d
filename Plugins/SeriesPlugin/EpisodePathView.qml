import QtQuick 2.0

Item
{
    id : episodes_pathview_container
    property alias model : followed_series_episodes_pathview.model

    states : [State    {PropertyChanges {target: episode_path; x_target : followed_series_episodes_pathview.width / 2} when : !seriesplugin_item.consultingEpisode},
              State    {PropertyChanges {target: episode_path; x_target : followed_series_episodes_pathview.width} when : seriesplugin_item.consultingEpisode}]
    transitions: Transition {SmoothedAnimation {target : episode_path; properties : "x_target"; duration : 750; velocity : 10}}

    PathView
    {
        id : followed_series_episodes_pathview
        smooth : true
        anchors.fill : parent
        focus : true
        flickDeceleration : 200
        preferredHighlightBegin: 0.50
        preferredHighlightEnd : 0.55
        pathItemCount : 8
        path :  Path {
            id : episode_path
            property real x_target : width / 2
            // TOP
            startX : width
            startY : 0
            PathPercent {value : 0}
            PathAttribute {name : "delScale"; value : 0.5}
            PathAttribute {name : "delZ"; value : 0.5}
            PathAttribute {name : "delAngle"; value : -60}
            PathAttribute {name : "delOpacity"; value : 0.7}
            // MIDDLE
            PathCurve { x: episode_path.x_target; y: height / 2}
            PathPercent {value : 0.5}
            PathAttribute {name : "delScale"; value : 1}
            PathAttribute {name : "delZ"; value : 1}
            PathAttribute {name : "delAngle"; value : 0}
            PathAttribute {name : "delOpacity"; value : 1}
            // BOTTOM
            PathCurve { x: width; y: mainWindow.height}
            PathPercent {value : 1.0}
            PathAttribute {name : "delScale"; value : 0.5}
            PathAttribute {name : "delZ"; value : 0.5}
            PathAttribute {name : "delAngle"; value : -60}
            PathAttribute {name : "delOpacity"; value : 0.7}
        }
        delegate : EpisodeListViewDelegate   {
            episodeNumber : model.episodeNumber
            episodeTitle : model.episodeTitle
            episodeOverview : model.episodeSummary
            episodeAiring : model.episodeAiring
            episodeSickbeardStatus:  model.episodeSickbeardStatus
            img_src : model.imageUrl
            width : mainWindow.width / 4
            height : mainWindow.height / 4
        }
    }
}
