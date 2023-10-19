* @ValidationCode : MjotODA5NjQwMjA2OkNwMTI1MjoxNjgyNTgzNzQzMjI3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:52:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.RATE.CHANGE(Y.ARRAY)
*----------------------------------------------------------------
* Description: This Nofile Enquiry is to print the deal slip for
* Rate change in Direct debit.
*----------------------------------------------------------------
* Input Arg  : NA
* Output Arg : NA

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh        PACS00113076 - B.16  INITIAL CREATION
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------

    FN.REDO.NOTIFY.RATE.CHANGE = 'F.REDO.NOTIFY.RATE.CHANGE'
    F.REDO.NOTIFY.RATE.CHANGE = ''
    CALL OPF(FN.REDO.NOTIFY.RATE.CHANGE,F.REDO.NOTIFY.RATE.CHANGE)

RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
    Y.ARRAY = ''
    FILE.NAME = FN.REDO.NOTIFY.RATE.CHANGE

    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '', SEL.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
    CALL EB.READLIST(SEL.CMD,ID.LST,'',NO.OF.REC,SEL.ERR)

    IF ID.LST THEN
        GOSUB FORM.ARRAY
    END


RETURN
*-----------------------------------------------------------
FORM.ARRAY:
*-----------------------------------------------------------
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        Y.ID = ID.LST<Y.VAR1>
        CALL F.READ(FN.REDO.NOTIFY.RATE.CHANGE,Y.ID,R.RATE.CHANGE,F.REDO.NOTIFY.RATE.CHANGE,NOTIFY.ERR)
        IF R.RATE.CHANGE<7> THEN
            Y.ARRAY<-1> = Y.ID:'*':R.RATE.CHANGE<7>:'*':R.RATE.CHANGE<8>
        END
        Y.VAR1 += 1
    REPEAT


RETURN
END
