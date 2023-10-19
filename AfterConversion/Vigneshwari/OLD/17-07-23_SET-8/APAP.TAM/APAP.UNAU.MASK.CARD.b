* @ValidationCode : MjotMjEwNTI2NTEyNDpDcDEyNTI6MTY4OTMzNzY3NTg3Mjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 17:57:55
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			               AUTHOR			Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL     AUTO R22 CODE CONVERSION		   ../T24_BP & TAM.BP is removed in insertfile , FM is changed to @FM,'CONVERT' is changed to 'CHANGE',++ is changed to +=1
*13/07/2023	               VIGNESHWARI  	    MANUAL R22 CODE CONVERSION		          NOCHANGE
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE APAP.UNAU.MASK.CARD

*Desc: To update the oginial value for the debit/credit card which was masked by workarround routine
*Linked to : Version control routine - ID routine APAP.ID.MASK.CARD
*By : Nishant Yadav
*Date : 20180313

    $INSERT I_COMMON    ;*AUTO R22 CODE CONVERSION-START
    $INSERT I_System
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.APAP.PARAM.DB.CR.MASK
    $INSERT I_F.LATAM.CARD.ORDER   ;*AUTO R22 CODE CONVERSION-END

    GOSUB INIT
    GOSUB UPD.ORG.VAL

RETURN
*----------------------------------------------------------------
INIT:

    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"  ; F.APAP.PARAM.DB.CR.MASK = "" ; CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)
    FN.APP = "F.":APPLICATION ; F.APP = "" ; CALL OPF(FN.APP,F.APP)
    FN.APP.NAU = "F.":APPLICATION:"$NAU":@FM:'NO.FATAL.ERROR' ; F.APP.NAU = "" ; CALL OPF(FN.APP.NAU,F.APP.NAU)
    IF ETEXT THEN
        NAU.NOT.EXIST=1
    END

    Y.VER.FLD.LST = ""
    Y.VER.NAME = APPLICATION:PGM.VERSION
    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,Y.VER.NAME,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
    IF R.MASK.PARAM THEN

        Y.VER.FLD.LST = R.MASK.PARAM<APAP.MASK.VER.FLD.ENQ.COL>
        Y.PARAM.DIGIT = R.MASK.PARAM<APAP.MASK.MASKING.DIGITS>

        Y.CARD.LIST =  System.getVariable('CURRENT.CARD.LIST.INP')
    END ELSE
        RETURN
    END

    CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.SS)

    IF R.SS THEN
        Y.FIELD.NAMES = R.SS<SSL.SYS.FIELD.NAME>
    END

RETURN
*--------------------------------------------------------------------
UPD.ORG.VAL:

    IF Y.VER.FLD.LST THEN
        Y.INIT = 1
        Y.MAX = DCOUNT(Y.CARD.LIST,@FM)
        LOOP
            Y.CURR.VAL = FIELD(Y.CARD.LIST,@FM,Y.INIT,1)
            Y.VER.FLD = FIELD(Y.CURR.VAL,"*",1,1)
            Y.VER.FLD.VAL.ALL = FIELD(Y.CURR.VAL,"*",2,LEN(Y.CURR.VAL))
        WHILE Y.INIT LE Y.MAX
            LOCATE Y.VER.FLD IN Y.FIELD.NAMES<1,1> SETTING Y.POS.SS.FIELD THEN
                Y.SS.FIELD.POS = R.SS<SSL.SYS.FIELD.NO,Y.POS.SS.FIELD>
                GOSUB RETAIN.CHECK.RTN.VAL
                CALL F.READ(FN.APP,ID.NEW,R.APP,F.APP,ERR.APP)
                IF R.APP AND Y.VER.FLD.VAL.ALL THEN
                    R.NEW(Y.SS.FIELD.POS) = YCARDS
                    R.APP<Y.SS.FIELD.POS> = YCARDS
                    CALL F.WRITE(FN.APP,ID.NEW,R.APP)
                    IF NOT(E) THEN
                        CALL System.setVariable('CURRENT.CARD.LIST', YCARDS)
                    END
                END
                CALL F.READ(FN.APP.NAU,ID.NEW,R.APP.NAU,F.APP.NAU,ERR.APP.NAU)
                IF R.APP.NAU THEN
                    R.APP.NAU<Y.SS.FIELD.POS> = YCARDS
                    CALL F.WRITE(FN.APP.NAU,ID.NEW,R.APP.NAU)
                END
            END
            Y.INIT += 1
        REPEAT
    END

RETURN
*--------------------------------------------------------------
RETAIN.CHECK.RTN.VAL:

    Y.CURR.VAL = R.NEW(Y.SS.FIELD.POS)
    YCARDS = Y.VER.FLD.VAL.ALL
    CHANGE " " TO @FM IN Y.PARAM.DIGIT ;*AUTO R22 CODE CONVERSION

    Y.FM.CNT = DCOUNT(Y.CURR.VAL,@FM)
    Y.VM.CNT = DCOUNT(Y.CURR.VAL,@VM)
    IF Y.VM.CNT GT 1 AND Y.FM.CNT EQ 1 THEN
        FOR Y.CURR.INI = 1 TO Y.VM.CNT
            Y.MSK.CHK.CARD = Y.CURR.VAL<1,Y.CURR.INI>
            IF Y.MSK.CHK.CARD THEN
                GOSUB CHK.MASKING
            END ELSE
                Y.MSK.CHK.CARD = ""
            END
            IF Y.MSK.CHK.CARD.FLG EQ "" THEN
                YCARDS<1,Y.CURR.INI> = Y.CURR.VAL<1,Y.CURR.INI>
                Y.MSK.CHK.CARD = ""
            END
        NEXT
    END ELSE
        YCARDS = Y.CURR.VAL
    END

RETURN
*---------------------------------------
CHK.MASKING:
    Y.MSK.CHK.CARD.FLG = "1"
    CHANGE "-" TO "" IN Y.MSK.CHK.CARD ;*AUTO R22 CODE CONVERSION
    Y.TOT.CNT.MSK = DCOUNT(Y.PARAM.DIGIT,@FM)
    FOR INT.MSK = 1 TO Y.TOT.CNT.MSK
        Y.MASKDIG = Y.PARAM.DIGIT<INT.MSK>
        Y.VAL = Y.MSK.CHK.CARD[Y.MASKDIG,1]
        IF (Y.VAL NE "*") AND Y.MSK.CHK.CARD.FLG NE "" THEN
            Y.MSK.CHK.CARD.FLG = ""
        END
    NEXT

RETURN
*----------------------------------------
END
