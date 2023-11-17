* @ValidationCode : MjoxNDQ2MzIxMzMxOkNwMTI1MjoxNjgzMDI0MzM2ODE3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:36
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

*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, ++ TO +=
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.VAL.REFER.REASON
*--------------------------------------------------------------
*Description: This routine is the validation routine for RCI,APPROVE.
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB PROCESS
RETURN

*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------



    Y.NEW.REFER.REASON = R.NEW(CLEAR.CHQ.REASON)
    Y.OLD.REFER.REASON = R.OLD(CLEAR.CHQ.REASON)

    Y.STATUS = R.NEW(CLEAR.CHQ.STATUS)
    IF Y.STATUS EQ 'PAID' OR Y.STATUS EQ 'REFERRED' THEN
        GOSUB PROCESS.PAID
    END
    IF Y.STATUS EQ 'REJECTED' THEN
        GOSUB PROCESS.REJECTED
    END

RETURN
*--------------------------------------------------------------
PROCESS.PAID:
*--------------------------------------------------------------
    IF Y.NEW.REFER.REASON NE Y.OLD.REFER.REASON THEN
        R.NEW(CLEAR.CHQ.REASON) = Y.OLD.REFER.REASON
        AF = CLEAR.CHQ.REASON
        ETEXT = 'EB-REDO.NO.CHANGE.REASON'
        CALL STORE.END.ERROR
    END
RETURN
*--------------------------------------------------------------
PROCESS.REJECTED:
*--------------------------------------------------------------

    IF Y.NEW.REFER.REASON NE Y.OLD.REFER.REASON THEN

        Y.REASON.COUNT = DCOUNT(Y.NEW.REFER.REASON,@VM)
        Y.VAR1 = 1

        LOOP
        WHILE Y.VAR1 LE Y.REASON.COUNT
            LOCATE Y.NEW.REFER.REASON<1,Y.VAR1> IN Y.OLD.REFER.REASON<1,1> SETTING POS1 ELSE
                R.NEW(CLEAR.CHQ.REASON) = Y.OLD.REFER.REASON
                AF = CLEAR.CHQ.REASON
                ETEXT = 'EB-REDO.NO.CHANGE.REASON'
                CALL STORE.END.ERROR
                RETURN
            END
            Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT

    END
RETURN
END
