* @ValidationCode : Mjo1NDQ4MDg5NTU6Q3AxMjUyOjE2ODA3ODE1MzE3MTc6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:15:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.RECORD
*-----------------------------------------------------------------------------
*!
*! This routine get the description for the ID limit from REDO.CCRG.LIMIT virtual table of the EB.LOOKUP application
*!
* @author:  anoriega@temenos.com
* @stereotype recordcheck: R.NEW
* @package: REDO.CCRG
* @uses E
* @uses AF
*!
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - Line -57 package name added
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
*
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES
    $INSERT I_REDO.CCRG.CONSTANT.COMMON

*----------------------------------------------------------------------
* Check if the record is okay to input to...

    Y.FLAG = 'N'
    GOSUB CHECK.RECORD
    IF E EQ '' THEN ;* R22 Auto conversion
        GOSUB SET.ENRICHMENTS
    END

RETURN

*-----------------------------------------------------------------------------
SET.ENRICHMENTS:
* DESCRIPTION
    R.NEW(REDO.CCRG.RLP.DESCRIPTION) = Y.ENRI2
* LOCAL CCY
    R.NEW(REDO.CCRG.RLP.LOCAL.CCY)   = LCCY
* MAX VALUE
    IF Y.FLAG NE 'S' THEN
        IF R.NEW(REDO.CCRG.RLP.PERCENTAGE) THEN       ;*This is because, the firts inputed it field will be empty
            CALL APAP.TAM.REDO.CCRG.CAL.MAX.AMOUNT('RECORD') ;* R22 Manual Conversion
        END
    END ELSE
        Y.AMOUNT.TEC.RES =R.TECH.RES<REDO.CCRG.TR.TECH.RES.AMOUNT>
        Y.PORCEN.CAL = R.NEW(REDO.CCRG.RLP.MAX.AMOUNT) * 100 /Y.AMOUNT.TEC.RES
        R.NEW(REDO.CCRG.RLP.PERCENTAGE) = Y.PORCEN.CAL
    END
RETURN

*--------------------------------------------------------------------
CHECK.RECORD:
    LOOP.CNT         = 1
    MAX.LOOPS        = 2
* Input not allowed for matured contracts!
*IF V$FUNCTION EQ 'I' THEN
* Get description for the RISK LIMIT PARAM
    Y.VIRTUAL.TABLE = 'REDO.CCRG.LIMIT*'
    Y.ID            = ID.NEW
    Y.I1            = Y.VIRTUAL.TABLE : Y.ID
    Y.ENRI2         = ''
    R.EB.LOOKUP     = ''
    Y.ERR           = ''

    CALL CACHE.READ('F.EB.LOOKUP',Y.I1,R.EB.LOOKUP,YERR)
    Y.ENRI2 = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
    IF Y.ENRI2 EQ "" THEN
        Y.ENRI2 = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
    END
    IF NOT(Y.ENRI2) THEN
        AF = REDO.CCRG.RLP.DESCRIPTION
        E  = 'ST-REDO.CCRG.ID.LIMIT.IS.NOT.ALLOWED'
        RETURN
    END

* Get currency from the REDO.CCRG.TECHNICAL.RESERVES application
    TEC.RES.ID = 'SYSTEM'
    R.TECH.RES = ''
    YERR       = ''
    CALL CACHE.READ('F.REDO.CCRG.TECHNICAL.RESERVES',TEC.RES.ID,R.TECH.RES,YERR)
    IF YERR NE '' THEN
        AF = REDO.CCRG.RLP.LOCAL.CCY
        E  = K.REC.NOT.FOUND : @FM : "SYSTEM" : @VM : 'F.REDO.CCRG.TECHNICAL.RESERVES'
        RETURN
    END

    IF Y.ID EQ 'HOUSING.PLAN.APAP' THEN ;* R22 Auto conversion
        Y.FLAG = 'S'
        T(REDO.CCRG.RLP.MAX.AMOUNT)<3> = ""
    END ELSE
        T(REDO.CCRG.RLP.MAX.AMOUNT)<3> = "NOINPUT"
    END

* In that case a CONDITION is not required
    Y.FIELD.COND.INP = ""
    IF Y.ID EQ 'RISK.GROUP.TOTAL' THEN
        R.NEW(REDO.CCRG.RLP.APPLICATION) = ""
        Y.FIELD.COND.INP = "NOINPUT"
    END

    T(REDO.CCRG.RLP.APPLICATION)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.FIELD.NO)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.OPERATOR)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.MIN.VALUE)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.MAX.VALUE)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.BOOL.OPER)<3> = Y.FIELD.COND.INP
    T(REDO.CCRG.RLP.FSHOW.TDIS)<3> = Y.FIELD.COND.INP


RETURN
*-----------------------------------------------------------------------------
END
