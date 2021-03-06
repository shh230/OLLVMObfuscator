; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=ipsccp | FileCheck %s

define void @main() {
; CHECK-LABEL: @main(
; CHECK:         %call = call i1 @patatino(i1 undef)
; CHECK-NEXT:    ret void
;
  %call = call i1 @patatino(i1 undef)
  ret void
}

define internal i1 @patatino(i1 %a) {
; CHECK-LABEL: define internal i1 @patatino(
; CHECK-NEXT:    br label [[ONFALSE:%.*]]
; CHECK-EMPTY:
; CHECK-NEXT:  onfalse:
; CHECK-NEXT:    ret i1 undef
  br i1 %a, label %ontrue, label %onfalse
ontrue:
  ret i1 false
onfalse:
  ret i1 false
}
