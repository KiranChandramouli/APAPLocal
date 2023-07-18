*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.UNAU.MASK.CARD

*Desc: To update the oginial value for the debit/credit card which was masked by workarround routine
*Linked to : Version control routine - ID routine APAP.ID.MASK.CARD
*By : Nishant Yadav
*Date : 20180313

    $INSERT ../T24_BP I_COMMON
    $INSERT ../T24_BP I_System
    $INSERT ../T24_BP I_EQUATE
    $INSERT ../T24_BP I_F.FUNDS.TRANSFER
    $INSERT ../T24_BP I_F.STANDARD.SELECTION
    $INSERT TAM.BP I_F.APAP.PARAM.DB.CR.MASK
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER

    GOSUB INIT
    GOSUB UPD.ORG.VAL

    RETURN
*----------------------------------------------------------------
INIT:

    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"  ; F.APAP.PARAM.DB.CR.MASK = "" ; CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)
    FN.APP = "F.":APPLICATION ; F.APP = "" ; CALL OPF(FN.APP,F.APP)
    FN.APP.NAU = "F.":APPLICATION:"$NAU":FM:'NO.FATAL.ERROR' ; F.APP.NAU = "" ; CALL OPF(FN.APP.NAU,F.APP.NAU)
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
        Y.MAX = DCOUNT(Y.CARD.LIST,FM)
        LOOP
            Y.CURR.VAL = FIELD(Y.CARD.LIST,FM,Y.INIT,1)
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
            Y.INIT++
        REPEAT
    END

    RETURN
*--------------------------------------------------------------
RETAIN.CHECK.RTN.VAL:

    Y.CURR.VAL = R.NEW(Y.SS.FIELD.POS)
    YCARDS = Y.VER.FLD.VAL.ALL
    CONVERT " " TO FM IN Y.PARAM.DIGIT

    Y.FM.CNT = DCOUNT(Y.CURR.VAL,FM)
    Y.VM.CNT = DCOUNT(Y.CURR.VAL,VM)
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
    CONVERT "-" TO "" IN Y.MSK.CHK.CARD
    Y.TOT.CNT.MSK = DCOUNT(Y.PARAM.DIGIT,FM)
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
