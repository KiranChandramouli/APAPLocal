* @ValidationCode : MjoxMDQ0NzY0MzU2OkNwMTI1MjoxNjg0MjIyODMwNjU3OklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           INCLUDE TO INSERT
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.CONV.CHQ.STAT
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS ;*AUTO R22 CODE CONVERSION - END

    GOSUB INIT
    GOSUB PROCESS
RETURN
 
INIT:
*****
    YSTATUS = ''; YAMOUNT = ''; YINP = ''; YADD.INFO = ''; YTP.INFO = ''; YTXN.VAL = ''
    YTXN.DTE = ''; YTXN.REF = ''; TOT.DB = 0; TOT.CR = 0; TOT.CRAMT = 0; TOT.DRAMT = 0
RETURN

PROCESS:
********
    YTXN.REF = R.RECORD<ADMIN.CHQ.DET.TRANS.REFERENCE>
    YSTATUS = R.RECORD<ADMIN.CHQ.DET.STATUS>
    YAMOUNT = O.DATA
    YINP = R.RECORD<ADMIN.CHQ.DET.INPUTTER>
    YADD.INFO = R.RECORD<ADMIN.CHQ.DET.ADDITIONAL.INFO>

    IF (YSTATUS EQ 'PAID') OR (YSTATUS EQ 'CANCELLED') THEN
        YAMOUNT = YAMOUNT * (-1)
        TOT.DB = 1
        TOT.DRAMT = YAMOUNT
    END ELSE
        TOT.CR = 1
        TOT.CRAMT = YAMOUNT
    END

    IF YADD.INFO THEN
        FINDSTR YSTATUS IN YADD.INFO<1> SETTING YFM, YVM, YSM THEN
            YTP.INFO = YADD.INFO<YFM,YVM>
            YTXN.VAL = FIELD(YTP.INFO,'-',2)
            YTXN.DTE = FIELD(YTP.INFO,'-',3)
        END
        IF YTXN.VAL AND YTXN.VAL EQ YTXN.REF THEN
            YTXN.VAL = ''
        END

    END
    IF YSTATUS EQ 'CANCELLED' AND YTXN.VAL EQ '' THEN
        YTXN.VAL = YTXN.REF
    END
    YINP = FIELD(YINP,'_',2)
    YINP = FIELD(YINP,'_',1)
    O.DATA = YAMOUNT:"*":YINP:"*":YTXN.VAL:"*":YTXN.DTE:"*":TOT.DB:"*":TOT.CR:"*":TOT.DRAMT:"*":TOT.CRAMT
RETURN
END
