* @ValidationCode : Mjo5Njk3NTQ3NTM6Q3AxMjUyOjE2ODIwNjk5NDA1NDA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:09:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.LAPAP.I.DEFAULT.DOC.DETS
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Bernard Gladin S
* Program Name  : REDO.LAPAP.I.DEFAULT.DOC.DETS
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This AUTO NEW CONTENT routine attached to the TT VERSIONs to populate TT.LEGAL.ID and TT.DOC.NUM local reference
*                 fields Using common variable VAR.CUS.DETAILS
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 17-APR-2017      Bernard Gladin S   RTE Phase 2       Initial creation
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, BP Removed in Insert File
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_GTS.COMMON
*
    $INSERT I_REDO.ID.CARD.CHECK.COMMON ;*AUTO R22 CODE CONVERSION - END
*

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REFS
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------

    WVAR.NAME = "CURRENT.VAR.DETAILS"
    WVAR.VAL  = ""
    WPOS.X    = 0
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
    LOOP
        REMOVE WWVAR FROM WVAR.NAME SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END
    REPEAT
*
    Y.OFS.SRC = OFS$SOURCE.ID
*
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
GET.LOCAL.REFS:
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------

    APPL.NAME = "TELLER"
    FIELD.ARR = "L.TT.LEGAL.ID":@VM:"L.TT.CLIENT.COD":@VM:"L.TT.DOC.NUM":@VM:"L.TT.DOC.DESC":@VM:"L.TT.CLIENT.NME"
    FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.ARR,FIELD.POS)

    L.TT.LEGAL.ID.POS = FIELD.POS<1,1>
    L.TT.CLIENT.COD.POS = FIELD.POS<1,2>
    L.TT.DOC.NUM.POS = FIELD.POS<1,3>
    L.TT.DOC.DESC.POS = FIELD.POS<1,4>
    L.TT.CLIENT.NME.POS = FIELD.POS<1,5>

RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    PROCESS.GOAHEAD = 1
    IF APPLICATION EQ "TELLER" AND Y.OFS.SRC EQ "FASTPATH" THEN
        PROCESS.GOAHEAD = ""
        RETURN
    END
*
    IF WVAR.VAL EQ "" THEN
        Y.ERR.MSG = "EB-USER.VARIABLE.&.NOT.DEFINED":@FM:WVAR.NAME
        PROCESS.GOAHEAD = ""
    END

RETURN

*--------
PROCESS:
*--------

    INTERCEPT.VAR = WVAR.VAL<1>
    CHANGE "*" TO @FM IN INTERCEPT.VAR
    IDENTITY.REFERENCE = ""
    IDENTITY.REFERENCE = INTERCEPT.VAR<1>:".":INTERCEPT.VAR<2>:".":INTERCEPT.VAR<3>
    CUSTOMER.NO = INTERCEPT.VAR<4>

    IF R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS> EQ "" THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS> = IDENTITY.REFERENCE
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.COD.POS> = CUSTOMER.NO
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = INTERCEPT.VAR<1>
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = INTERCEPT.VAR<2>
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS> = INTERCEPT.VAR<3>
    END

RETURN

END
