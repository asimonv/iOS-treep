//
//  Settings.swift
//  treep
//
//  Created by Andre Simon on 12/18/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

struct Settings {
    
    // MARK: GET requests
    var getTeacher = "http://ccomparte.cl/treep/api/1/get_teacher/"
    var searchTeachers = "http://ccomparte.cl/treep/api/1/search_teachers/"
    var getCourses = "http://ccomparte.cl/treep/api/1/get_courses/"
    var getUserCoursesStats = "http://ccomparte.cl/treep/api/1/get_user_courses_stats/"
    var getCourseVotes = "http://ccomparte.cl/treep/api/1/get_course_votes/"
    var getTeacherCourses = "http://ccomparte.cl/treep/api/1/get_teacher_courses"
    var getTeacherComments = "http://ccomparte.cl/treep/api/1/get_teacher_comments"
    var getTeachersRelated = "http://ccomparte.cl/treep/api/1/get_teachers"
    var getTeacherVotes = "http://ccomparte.cl/treep/api/1/get_teacher_stats/"
    var getTeacherEndorses = "http://ccomparte.cl/treep/api/1/get_teacher_endorses/"
    var getBestStat = "http://ccomparte.cl/treep/api/1/get_best_stat/"
    var recieveKey = "http://ccomparte.cl/treep/api/1/get_key"
    var getStats = "http://ccomparte.cl/treep/api/1/get_stats"
    
    // MARK: POST requests
    var endorseCourse = "http://ccomparte.cl/treep/api/1/endorse_teacher/"
    var commentTeacher = "http://ccomparte.cl/treep/api/1/comment_teacher/"
    var teacherStat = "http://ccomparte.cl/treep/api/1/post_teacher_stat/"
    var postCourseStat = "http://ccomparte.cl/treep/api/1/post_course_stat/"
    
    // MARK: Constants
    
    //Style
    var viewCornerRadius: CGFloat = 5
    
    //Notification
    var animationInStyle = CWNotificationAnimationStyle.top
    var animationOutStyle = CWNotificationAnimationStyle.top
    var notificationStyle = CWNotificationStyle.statusBarNotification
    var notificationColor = UIColor.colorFromHex(hexString: "#007AFF")
    var notificationFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
    var endorseText = "Endorse"
    var unEndorseText = "Remove Vote"
    var addCourseText = "Add"
    var removeCourseText = "Remove"
    var thanksForVotingText = "Thanks for voting! :)"
    var thanksForComment = "Thanks for the comment! :)"
    var courseAddedText = "Course added"
    var courseRemovedText = "Course removed"
}
