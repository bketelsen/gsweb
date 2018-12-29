include karax / prelude
include karax / kajax
import options, json, httpcore,strformat,sugar,strutils

type
  Course* = ref object
    name*: string
    description*: string

  CourseList* = ref object
   courses*: seq[Course]

  State = ref object
    list: Option[CourseList]
    loading: bool
    status: HttpCode

  CourseArray* =seq[Course]


proc newState(): State =
  State(
    list: none[CourseList](),
    loading: false,
    status: Http200,
  )

var
  state = newState()

proc onCourseList(httpStatus: int, response: cstring) =
  state.loading = false
  state.status = httpStatus.HttpCode
  if state.status != Http200: return
  let parsed = parseJson($response)
  let list = to(parsed, CourseArray)

  if state.list.isSome:
    state.list.get().courses.add(list)
  else:
    state.list = some(CourseList(
      courses: list,
      )
    )


proc createDom(): VNode =
  if state.list.isNone:
    if not state.loading:
      state.loading = true
      ajaxGet("/courses", @[("Accept".cstring,"application/json".cstring)], onCourseList)
    return buildHtml(tdiv):
      text "loading"
  let list = state.list.get()
  result = buildHtml():
      tdiv():
        for i in 0..< list.courses.len:
          let course = list.courses[i]
          text $course.name




setRenderer createDom
