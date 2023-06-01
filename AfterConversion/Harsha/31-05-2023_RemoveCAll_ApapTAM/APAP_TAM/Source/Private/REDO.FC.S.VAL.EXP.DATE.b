* @ValidationCode : MjotMTY5NjEzNzY1NjpDcDEyNTI6MTY4NDQ5MTAzNDEzMzpJVFNTOi0xOi0xOi00MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -40
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.VAL.EXP.DATE
* ============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TYPE.RATE.REV
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : FEB 25 2013
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM, ++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*============================================================================

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
******************************************************************************

    GOSUB INITIALISE
    GOSUB PROCESS


RETURN


RETURN
*
* =========
INITIALISE:
* =========
*
    Y.LOAN.TERM  = R.NEW (REDO.FC.TERM)
    Y.PAYMT.DAY  = R.NEW(REDO.FC.PAYMT.DAY)
    Y.COLL.TP = R.NEW(REDO.FC.TYPE.OF.SEC.TP)
    Y.NUM.COL.TP = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.TP),@VM)
    Y.COLL.DI = R.NEW(REDO.FC.TYPE.OF.SEC.DI)
    Y.NUM.COL.DI = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.DI),@VM)
    Y.COLL.DE = R.NEW(REDO.FC.TYPE.OF.SEC.DE)
    Y.NUM.COL.DE = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.DI),@VM)

    Y.LOAN.MAT.DATE = ''
    Y.EFEC.DATE  = R.NEW(REDO.FC.EFFECT.DATE)
    Y.EFEC.DAY   = ''
RETURN

*
* ======
PROCESS:
* ======
*
    GOSUB EVAL.LOAN.TERM
    BEGIN CASE

        CASE R.NEW(REDO.FC.TYPE.OF.SEC.TP) NE ''

            Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.TP)
            Y.COL.INS.DT = R.NEW (REDO.FC.NATION.DATE.PYR.TP)
            Y.NUM.COL.TYPE = DCOUNT(Y.COLL.TYPE,@VM)
            Y.ID.INST = R.NEW(REDO.FC.INSMNT.NO.TP)
            GOSUB EVAL.COLLATERAL

        CASE  R.NEW(REDO.FC.TYPE.OF.SEC.DI) NE ''

            Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.DI)
            Y.COL.INS.DT = R.NEW (REDO.FC.MATUR.DATE.DI)
            Y.NUM.COL.TYPE = DCOUNT(Y.COLL.TYPE,@VM)
            Y.ID.INST = R.NEW(REDO.FC.NUM.INST.COLL.DI)
            GOSUB EVAL.COLLATERAL

        CASE R.NEW(REDO.FC.TYPE.OF.SEC.DE) NE ''

            Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.DE)
            Y.COL.INS.DT = R.NEW (REDO.FC.MATUR.DATE.DE)
            Y.ID.INST = R.NEW(REDO.FC.NUM.INSMNT.GTIA.DE)
            Y.NUM.COL.TYPE = DCOUNT(Y.COLL.TYPE,@VM)
            GOSUB EVAL.COLLATERAL

    END CASE
RETURN
*-------------------------------------
EVAL.LOAN.TERM:
*-------------------------------------
    CALL CALENDAR.DAY( Y.EFEC.DATE ,'+', Y.LOAN.TERM)
    Y.EFEC.DAY = Y.LOAN.TERM[6,2]
    Y.EF.DAT   = Y.LOAN.TERM[1,6]
    IF Y.PAYMT.DAY LE Y.EFEC.DAY THEN
        Y.MONTH = "00"
    END
    ELSE
        Y.MONTH = "01"
    END
    Y.COMI     = COMI
    COMI       = Y.EF.DAT:"01": "M":Y.MONTH:Y.PAYMT.DAY

    CALL CFQ
    Y.LOAN.MAT.DATE     = COMI[1,8]
    COMI       = Y.COMI
RETURN

*-------------------------------------
SEND.OVERRIDE:
*-------------------------------------

    TEXT = 'EB.MAT.INST.LT.LOAN.MAT':@FM:Y.ID.INST<1,Y.ITR>
    NRO.OVE = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
    CALL STORE.OVERRIDE(NRO.OVE)

RETURN
*-------------------------------------
EVAL.COLLATERAL:
*-------------------------------------
    Y.ITR = 1
    LOOP
    WHILE Y.ITR LE Y.NUM.COL.TYPE
        IF Y.COL.INS.DT<1,Y.ITR> AND Y.COL.INS.DT<1,Y.ITR> LT Y.LOAN.MAT.DATE THEN
            GOSUB SEND.OVERRIDE
        END
        Y.ITR += 1  ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN


END
