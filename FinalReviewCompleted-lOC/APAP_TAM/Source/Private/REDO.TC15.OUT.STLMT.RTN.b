* @ValidationCode : MjotODg2NDE0NzY3OkNwMTI1MjoxNjgzMDE4MDk1Mjg3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TC15.OUT.STLMT.RTN(VISA.OUTGOING)
**--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC15.OUT.STLMT.RTN
*Date              : 23.11.2010
*-------------------------------------------------------------------------
*Description:
*-------------
*This routine is used to frame the file lines
*
*
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010              H GANESH             ODR-2010-08-0469       Initial Version
*30/11/2012              Prabhu               mandis 0002920         constant check added
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - Add call routine prefix
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.VISA.STLMT.MAPPING
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
*$INCLUDE TAM.BP I_REDO.VISA.GEN.OUT.COMMON
	$USING APAP.TAM
	
    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
    LINE=''
    LINE.ARRAY=''
    R.REDO.VISA.OUTGOING=VISA.OUTGOING
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    Y.VAR1=0
    LOOP
    WHILE Y.VAR1 LE 1

        IF LINE NE '' THEN

            LINE.ARRAY<-1>=LINE
            LINE=''
        END
        Y.TC.CODE=TC.CODE:Y.VAR1
        CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,Y.TC.CODE,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,REDO.MAP.ERR)
        Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
        GOSUB FIELD.VALIDATE

        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT

    IF LINE NE '' THEN
        LINE.ARRAY<-1>=LINE
        LINE=''
    END
    Y.OTHER.TCR.LINES=R.REDO.VISA.OUTGOING<VISA.OUT.OTHER.TCR.LINE>
    IF Y.OTHER.TCR.LINES NE '' THEN
        CHANGE @VM TO @FM IN Y.OTHER.TCR.LINES
        LINE.ARRAY<-1>=Y.OTHER.TCR.LINES

    END
*LINE.ARRAY<-1>=Y.VISA.OUT.ID

    CALL F.WRITE(FN.VISA.OUT.CHGBCK.LINES,Y.VISA.OUT.ID,LINE.ARRAY)
    R.REDO.VISA.OUTGOING<VISA.OUT.STATUS>='SENT'
    CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING)

RETURN
*------------------------------------------------------------------------------------
FIELD.VALIDATE:
*------------------------------------------------------------------------------------

    Y.NO.OF.FIELD=DCOUNT(Y.FIELD.NAME,@VM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.NO.OF.FIELD
        GOSUB FIELD.PROCESS
        VAR2 += 1 ;* R22 Auto conversion
    REPEAT

RETURN
*------------------------------------------------------------------------------------
FIELD.PROCESS:
*------------------------------------------------------------------------------------
*Changes realted to mandis
    Y.CONSTANT=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.CONSTANT,VAR2>
    Y.FLD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME,VAR2>
    Y.FIELD.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NO,VAR2>
    Y.END.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,VAR2>
    VERIFY.OUT.RTN=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.OUT.RTN,VAR2>
    Y.FIELD.VALUE=R.REDO.VISA.OUTGOING<Y.FIELD.POS>
    IF Y.CONSTANT NE '' THEN
        Y.FIELD.VALUE=Y.CONSTANT
    END
    LEN.FIELD=Y.END.POS
    PADDING.STR=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.PADDING,VAR2>
    IF VERIFY.OUT.RTN NE '' THEN
        CALL @VERIFY.OUT.RTN
    END
*CALL REDO.FMT.OUT.PADDING
**R22 manual conversion
    CALL APAP.TAM.redoFmtOutPadding()
    IF ERROR.MESSAGE NE '' THEN
        R.REDO.VISA.OUTGOING<VISA.OUT.STATUS>='ERROR ':ERROR.MESSAGE
        CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING)
        RETURN
    END ELSE
        LINE:=Y.FIELD.VALUE

    END

RETURN
END
