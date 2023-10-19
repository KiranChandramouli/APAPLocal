$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, FM TO @FM, ++ TO +=1
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE APAP.AUTH.MASK.CARD

*Desc: To update the oginial value for the debit/credit card which was masked by workarround routine
*Linked to : Version control routine - ID routine APAP.ID.MASK.CARD
*By : Nishant Yadav
*Date : 20180313

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_System
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.APAP.PARAM.DB.CR.MASK
    $INSERT I_F.LATAM.CARD.ORDER ;*R22 AUTO CONVERSION END

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
        Y.MAX = DCOUNT(Y.CARD.LIST,@FM) ;*R22 AUTO CONVERSION
        LOOP
            Y.CURR.VAL = FIELD(Y.CARD.LIST,@FM,Y.INIT,1) ;*R22 AUTO CONVERSION
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
            Y.INIT += 1 ;*R22 AUTO CONVERSION
        REPEAT
    END

RETURN
*--------------------------------------------------------------
END
