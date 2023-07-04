* @ValidationCode : MjotMjk3MDM4NjkxOkNwMTI1MjoxNjgzMDAxNTI4NzM3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 09:55:28
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
SUBROUTINE  REDO.TC.OUT.STLMT.RTN(VISA.OUTGOING)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC.OUT.STLMT.RTN
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM,++ TO +=
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION       CALL Rtn format modified

*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISA.OUT.MAP
*$INCLUDE TAM.BP I_F.REDO.VISA.OUTGOING
    $INSERT I_F.VISA.TC40.OUT.FILE
    $INSERT I_F.REDO.VISA.TC52.FILE
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.VISA.STLMT.MAPPING
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
	$USING APAP.TAM


    GOSUB INIT
    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
    LINE=''
    LINE.ARRAY=''
    TCR.ARR=''
    R.REDO.VISA.OUTGOING=VISA.OUTGOING
RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------


    IF TC.CODE EQ 05 OR TC.CODE EQ 06 OR TC.CODE EQ 07 OR TC.CODE EQ 25 OR TC.CODE EQ 26 OR TC.CODE EQ 27 OR TC.CODE EQ 35 OR TC.CODE EQ 36 OR TC.CODE EQ 37 OR TC.CODE EQ 52 THEN
        TCR.ARR<1>=0
        TCR.ARR<2>=1

    END
    IF TC.CODE EQ 40 THEN
        TCR.ARR<1>=0
        TCR.ARR<2>=2
    END
    IF TC.CODE EQ 10 OR TC.CODE EQ 20 THEN
        TCR.ARR<1>=0
    END

    TCR.ARR.CNT=DCOUNT(TCR.ARR,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE TCR.ARR.CNT
        IF LINE NE '' THEN

            LINE.ARRAY<-1>=LINE
            LINE=''
        END

        IF TC.CODE EQ 05 AND TCR.ARR<Y.VAR1> EQ 0 THEN
            R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.050
            Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
            GOSUB FIELD.VALIDATE
            Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE

        END
        IF TC.CODE EQ 05 AND TCR.ARR<Y.VAR1> EQ 1 THEN
            R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.051
            Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
            GOSUB FIELD.VALIDATE
            Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE
        END
        IF TC.CODE EQ 07 AND TCR.ARR<Y.VAR1> EQ 0 THEN
            R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.070
            Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
            GOSUB FIELD.VALIDATE
            Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE
        END
        IF TC.CODE EQ 07 AND TCR.ARR<Y.VAR1> EQ 1 THEN
            R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.071
            Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
            GOSUB FIELD.VALIDATE
            Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE
        END
        Y.MAP.ID=TC.CODE:TCR.ARR<Y.VAR1>
        CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,Y.MAP.ID,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
        Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
        GOSUB FIELD.VALIDATE

        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    IF LINE NE '' THEN
        LINE.ARRAY<-1>=LINE
        LINE=''
    END

    IF TC.CODE EQ 07 THEN
        R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.074
        Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
        GOSUB FIELD.VALIDATE
        IF LINE NE '' THEN
            LINE.ARRAY<-1>=LINE
            LINE=''
        END
        R.REDO.VISA.STLMT.MAPPING=R.REDO.VISA.STLMT.MAPPING.075
        Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
        GOSUB FIELD.VALIDATE
        IF LINE NE '' THEN
            LINE.ARRAY<-1>=LINE
            LINE=''
        END
    END
    IF FIELD(Y.APPL,'.',2) EQ 'REDO.VISA.OUTGOING' THEN
        Y.OTHER.TCR.LINES=R.REDO.VISA.OUTGOING<INS.OTHR.TCR>
        IF Y.OTHER.TCR.LINES NE '' THEN
            CHANGE @VM TO @FM IN Y.OTHER.TCR.LINES
            LINE.ARRAY<-1>=Y.OTHER.TCR.LINES

        END
    END
    CALL F.WRITE(FN.VISA.OUT.CHGBCK.LINES,Y.VISA.OUT.ID,LINE.ARRAY)
    R.REDO.VISA.OUTGOING<INS.STATUS>='SENT'

    CALL F.WRITE(Y.APPL,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING)

RETURN
*-------------------------------------------------------------------
FIELD.VALIDATE:
*-------------------------------------------------------------------

    Y.NO.OF.FIELD=DCOUNT(Y.FIELD.NAME,@VM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.NO.OF.FIELD
        GOSUB FIELD.PROCESS
        VAR2 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
*-------------------------------------------------------------------
FIELD.PROCESS:
*-------------------------------------------------------------------
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
    CALL APAP.TAM.redoFmtOutPadding()          ;*MANUAL R22 CODE CONVERSION
    
    IF ERROR.MESSAGE NE '' THEN
        R.REDO.VISA.OUTGOING<INS.STATUS>='ERROR ':ERROR.MESSAGE
        CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING)
        RETURN
    END ELSE
        LINE:=Y.FIELD.VALUE

    END

RETURN

END
