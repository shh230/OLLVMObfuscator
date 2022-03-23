; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S -verify | FileCheck %s

define i1 @ule_null_constexpr(i8* %x) {
; CHECK-LABEL: @ule_null_constexpr(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule i8 (...)* null, bitcast (i1 (i8*)* @ule_null_constexpr to i8 (...)*)
  ret i1 %cmp
}

define i1 @ugt_null_constexpr(i8* %x) {
; CHECK-LABEL: @ugt_null_constexpr(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt i8 (...)* null, bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*)
  ret i1 %cmp
}

define i1 @uge_constexpr_null(i8* %x) {
; CHECK-LABEL: @uge_constexpr_null(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp uge i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), null
  ret i1 %cmp
}

define i1 @ult_constexpr_null(i8* %x) {
; CHECK-LABEL: @ult_constexpr_null(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ult i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), null
  ret i1 %cmp
}

; Negative test - we don't know if the constexpr is null.

define i1 @ule_constexpr_null(i8* %x) {
; CHECK-LABEL: @ule_constexpr_null(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ule i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), null
  ret i1 %cmp
}

; Negative test - we don't know if the constexpr is *signed* less-than null.

define i1 @slt_constexpr_null(i8* %x) {
; CHECK-LABEL: @slt_constexpr_null(
; CHECK-NEXT:    ret i1 icmp slt (i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), i8 (...)* null)
;
  %cmp = icmp slt i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), null
  ret i1 %cmp
}

; Negative test - we don't try to evaluate this comparison of constant expressions.

define i1 @ult_constexpr_constexpr_one(i8* %x) {
; CHECK-LABEL: @ult_constexpr_constexpr_one(
; CHECK-NEXT:    ret i1 icmp ult (i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), i8 (...)* inttoptr (i32 1 to i8 (...)*))
;
  %cmp = icmp ult i8 (...)* bitcast (i1 (i8*)* @ugt_null_constexpr to i8 (...)*), inttoptr (i32 1 to i8 (...)*)
  ret i1 %cmp
}

@g = global [2 x i32] [i32 1, i32 2]
@g2 = global i32 0
@g2_weak = extern_weak global i32
@g3 = global i8 0

define i1 @global_ne_null() {
; CHECK-LABEL: @global_ne_null(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ne [2 x i32]* @g, null
  ret i1 %cmp
}

define i1 @global_ugt_null() {
; CHECK-LABEL: @global_ugt_null(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ugt [2 x i32]* @g, null
  ret i1 %cmp
}

define i1 @global_sgt_null() {
; CHECK-LABEL: @global_sgt_null(
; CHECK-NEXT:    ret i1 icmp sgt ([2 x i32]* @g, [2 x i32]* null)
;
  %cmp = icmp sgt [2 x i32]* @g, null
  ret i1 %cmp
}

; Should not fold to true, as the gep computes a null value.
define i1 @global_out_of_bounds_gep_ne_null() {
; CHECK-LABEL: @global_out_of_bounds_gep_ne_null(
; CHECK-NEXT:    ret i1 icmp ne (i8* getelementptr (i8, i8* @g3, i64 sub (i64 0, i64 ptrtoint (i8* @g3 to i64))), i8* null)
;
  %cmp = icmp ne i8* getelementptr (i8, i8* @g3, i64 sub (i64 0, i64 ptrtoint (i8* @g3 to i64))), null
  ret i1 %cmp
}

define i1 @global_inbounds_gep_ne_null() {
; CHECK-LABEL: @global_inbounds_gep_ne_null(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp ne [2 x i32]* %gep, null
  ret i1 %cmp
}

define i1 @global_gep_ugt_null() {
; CHECK-LABEL: @global_gep_ugt_null(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp ugt [2 x i32]* %gep, null
  ret i1 %cmp
}

define i1 @global_gep_sgt_null() {
; CHECK-LABEL: @global_gep_sgt_null(
; CHECK-NEXT:    ret i1 icmp sgt ([2 x i32]* getelementptr inbounds ([2 x i32], [2 x i32]* @g, i64 1), [2 x i32]* null)
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp sgt [2 x i32]* %gep, null
  ret i1 %cmp
}

; @g2_weak may be null, in which case this is a zero-index GEP and the pointers
; are equal.
define i1 @null_gep_ne_null() {
; CHECK-LABEL: @null_gep_ne_null(
; CHECK-NEXT:    ret i1 icmp ne (i8* getelementptr (i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)), i8* null)
;
  %gep = getelementptr i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)
  %cmp = icmp ne i8* %gep, null
  ret i1 %cmp
}

define i1 @null_gep_ugt_null() {
; CHECK-LABEL: @null_gep_ugt_null(
; CHECK-NEXT:    ret i1 icmp ugt (i8* getelementptr (i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)), i8* null)
;
  %gep = getelementptr i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)
  %cmp = icmp ugt i8* %gep, null
  ret i1 %cmp
}

define i1 @null_gep_sgt_null() {
; CHECK-LABEL: @null_gep_sgt_null(
; CHECK-NEXT:    ret i1 icmp sgt (i8* getelementptr (i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)), i8* null)
;
  %gep = getelementptr i8, i8* null, i64 ptrtoint (i32* @g2_weak to i64)
  %cmp = icmp sgt i8* %gep, null
  ret i1 %cmp
}

define i1 @null_gep_ne_null_constant_int() {
; CHECK-LABEL: @null_gep_ne_null_constant_int(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr i8, i8* null, i64 1
  %cmp = icmp ne i8* %gep, null
  ret i1 %cmp
}

define i1 @null_gep_ugt_null_constant_int() {
; CHECK-LABEL: @null_gep_ugt_null_constant_int(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr i8, i8* null, i64 1
  %cmp = icmp ugt i8* %gep, null
  ret i1 %cmp
}

define i1 @null_gep_ne_global() {
; CHECK-LABEL: @null_gep_ne_global(
; CHECK-NEXT:    ret i1 icmp ne (i8* getelementptr (i8, i8* null, i64 ptrtoint (i8* @g3 to i64)), i8* @g3)
;
  %gep = getelementptr i8, i8* null, i64 ptrtoint (i8* @g3 to i64)
  %cmp = icmp ne i8* %gep, @g3
  ret i1 %cmp
}

define i1 @null_gep_ult_global() {
; CHECK-LABEL: @null_gep_ult_global(
; CHECK-NEXT:    ret i1 icmp ult (i8* getelementptr (i8, i8* null, i64 ptrtoint (i8* @g3 to i64)), i8* @g3)
;
  %gep = getelementptr i8, i8* null, i64 ptrtoint (i8* @g3 to i64)
  %cmp = icmp ult i8* %gep, @g3
  ret i1 %cmp
}

define i1 @null_gep_slt_global() {
; CHECK-LABEL: @null_gep_slt_global(
; CHECK-NEXT:    ret i1 icmp slt ([2 x i32]* getelementptr ([2 x i32], [2 x i32]* null, i64 ptrtoint (i32* @g2 to i64)), [2 x i32]* @g)
;
  %gep = getelementptr [2 x i32], [2 x i32]* null, i64 ptrtoint (i32* @g2 to i64)
  %cmp = icmp slt [2 x i32]* %gep, @g
  ret i1 %cmp
}

define i1 @global_gep_ne_global() {
; CHECK-LABEL: @global_gep_ne_global(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp ne [2 x i32]* %gep, @g
  ret i1 %cmp
}

define i1 @global_gep_ugt_global() {
; CHECK-LABEL: @global_gep_ugt_global(
; CHECK-NEXT:    ret i1 true
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp ugt [2 x i32]* %gep, @g
  ret i1 %cmp
}

define i1 @global_gep_sgt_global() {
; CHECK-LABEL: @global_gep_sgt_global(
; CHECK-NEXT:    ret i1 icmp sgt ([2 x i32]* getelementptr inbounds ([2 x i32], [2 x i32]* @g, i64 1), [2 x i32]* @g)
;
  %gep = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 1
  %cmp = icmp sgt [2 x i32]* %gep, @g
  ret i1 %cmp
}

; This should not fold to true, as the offset is negative.
define i1 @global_gep_ugt_global_neg_offset() {
; CHECK-LABEL: @global_gep_ugt_global_neg_offset(
; CHECK-NEXT:    ret i1 icmp ugt ([2 x i32]* getelementptr ([2 x i32], [2 x i32]* @g, i64 -1), [2 x i32]* @g)
;
  %gep = getelementptr [2 x i32], [2 x i32]* @g, i64 -1
  %cmp = icmp ugt [2 x i32]* %gep, @g
  ret i1 %cmp
}

define i1 @global_gep_sgt_global_neg_offset() {
; CHECK-LABEL: @global_gep_sgt_global_neg_offset(
; CHECK-NEXT:    ret i1 icmp sgt ([2 x i32]* getelementptr ([2 x i32], [2 x i32]* @g, i64 -1), [2 x i32]* @g)
;
  %gep = getelementptr [2 x i32], [2 x i32]* @g, i64 -1
  %cmp = icmp sgt [2 x i32]* %gep, @g
  ret i1 %cmp
}

define i1 @global_gep_ugt_global_gep() {
; CHECK-LABEL: @global_gep_ugt_global_gep(
; CHECK-NEXT:    ret i1 true
;
  %gep1 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 0
  %gep2 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 1
  %cmp = icmp ugt i32* %gep2, %gep1
  ret i1 %cmp
}

; Should not fold due to signed comparison.
define i1 @global_gep_sgt_global_gep() {
; CHECK-LABEL: @global_gep_sgt_global_gep(
; CHECK-NEXT:    ret i1 icmp sgt (i32* getelementptr inbounds ([2 x i32], [2 x i32]* @g, i64 0, i64 1), i32* getelementptr inbounds ([2 x i32], [2 x i32]* @g, i64 0, i64 0))
;
  %gep1 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 0
  %gep2 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 1
  %cmp = icmp sgt i32* %gep2, %gep1
  ret i1 %cmp
}

define i1 @global_gep_ugt_global_gep_complex() {
; CHECK-LABEL: @global_gep_ugt_global_gep_complex(
; CHECK-NEXT:    ret i1 true
;
  %gep1 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 0
  %gep2 = getelementptr inbounds [2 x i32], [2 x i32]* @g, i64 0, i64 0
  %gep2.cast = bitcast i32* %gep2 to i8*
  %gep3 = getelementptr inbounds i8, i8* %gep2.cast, i64 2
  %gep3.cast = bitcast i8* %gep3 to i32*
  %cmp = icmp ugt i32* %gep3.cast, %gep1
  ret i1 %cmp
}