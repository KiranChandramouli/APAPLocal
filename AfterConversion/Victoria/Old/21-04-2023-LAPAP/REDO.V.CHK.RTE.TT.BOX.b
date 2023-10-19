$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.CHK.RTE.TT.BOX
*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*----------------------------------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : APAP
* PROGRAM NAME : REDO.V.CHK.RTE.TT.BOX
*
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                   REFERENCE       DESCRIPTION
*
* 20/01/2017    APAP                  RTE FIX         Tax Excemption getting reassigned to NO during validate
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM,VM TO @VM,SM TO @SM
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 AUTO CONVERSION

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    R.REDO.H.REPORTS.PARAM = ''
    RTE.PARAM.ERR = ''
    RTE.PARAM.ID = 'REDO.RTE.FORM'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,RTE.PARAM.ID,R.REDO.H.REPORTS.PARAM,RTE.PARAM.ERR)

    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
    LOCATE "RTE.VERSIONS" IN Y.FIELD.NME.ARR<1,1> SETTING RTE.VER.POS THEN
        Y.RTE.VERSIONS = Y.FIELD.VAL.ARR<1,RTE.VER.POS>
    END
    Y.RTE.VERSIONS = CHANGE(Y.RTE.VERSIONS,@SM,@VM) ;*R22 AUTO CONVERSION
    IF COMI[1,2] EQ 'TT' THEN
        GET.APPLICATION = 'TELLER'
    END
    Y.CURRENT.VERSION = GET.APPLICATION:PGM.VERSION

    CALL F.READ(FN.TELLER.NAU,COMI,R.TELLER,F.TELLER.NAU,TELLER.ERR)
    LOCATE Y.CURRENT.VERSION IN Y.RTE.VERSIONS<1,1> SETTING RTE.VER.POS ELSE
        IF V$FUNCTION EQ 'I' AND R.TELLER NE '' AND OFS$SOURCE.ID NE 'FASTPATH' THEN
            E = 'EB-CANNOT.AMEND.EXISTING.RECORD'
            CALL ERR
        END
    END

    IF R.TELLER EQ '' THEN
        CALL F.READ(FN.TELLER,COMI,R.TELLER,F.TELLER,TELLER.ERR)
    END

    IF (V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'I') AND R.TELLER NE '' THEN

        SET.USER.FLAG = ''

        GET.INPUTTER = R.TELLER<TT.TE.INPUTTER>
        GET.TT.USER = FIELDS(GET.INPUTTER,'_',2)
        IF GET.TT.USER EQ OPERATOR THEN
            SET.USER.FLAG = 1
        END

        IF NOT(SET.USER.FLAG) THEN

            IF V$FUNCTION EQ 'I' THEN
                E = 'EB-ONLY.SAME.OPERATOR.AMEND':@FM:GET.TT.USER ;*R22 AUTO CONVERSION
            END ELSE
                E = 'TT-REDO.TXN.OTHER.BOX'
            END
            CALL ERR
        END
    END

RETURN
