*-----------------------------------------------------------------------------
* <Rating>29</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.AUTH.MASK.CARD

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

    IF V$FUNCTION EQ "A" THEN
        GOSUB INIT
        IF Y.RET.FL EQ "1" THEN
            RETURN
        END
        GOSUB UPD.ORG.VAL
    END

    RETURN
*----------------------------------------------------------------
INIT:
    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"  ; F.APAP.PARAM.DB.CR.MASK = "" ; CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)
    FN.APP = "F.":APPLICATION ; F.APP = "" ; CALL OPF(FN.APP,F.APP)

    Y.VER.FLD.LST = ""
    Y.VER.NAME = APPLICATION:PGM.VERSION

    Y.RET.FL = 0
    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,Y.VER.NAME,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
    IF R.MASK.PARAM THEN
        Y.VER.FLD.LST = R.MASK.PARAM<APAP.MASK.VER.FLD.ENQ.COL>
        Y.CARD.LIST =  System.getVariable('CURRENT.CARD.LIST')
        FINDSTR "UNKNOWN.VARIABLE" IN E SETTING Ap, Vp THEN
            E = ""
            Y.RET.FL = 1
            RETURN
        END
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
                CALL F.READ(FN.APP,ID.NEW,R.APP,F.APP,ERR.APP)
                IF R.APP AND Y.VER.FLD.VAL.ALL THEN
                    R.APP<Y.SS.FIELD.POS> = Y.VER.FLD.VAL.ALL
*                    WRITE R.APP ON F.APP,ID.NEW
                    CALL F.WRITE(FN.APP,ID.NEW,R.APP)
                END
            END
            Y.INIT++
        REPEAT
    END

    RETURN
*--------------------------------------------------------------
END
