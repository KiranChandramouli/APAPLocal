* @ValidationCode : Mjo1MzQwNzkzMzA6Q3AxMjUyOjE2ODE3MjcxMzQ2MjA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 15:55:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.PARAM.V.CCY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.TT.PARAM.V.CCY
* ODR NO      : ODR-2009-12-0307
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in TELLER.PARAMETER,L.APAP version
* The functionality is to validate the limit transactions for a type of teller
* based on the currency entered.

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  TELLER.PARAMETER
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.12.2012  RMONDRAGON    ODR-2009-12-0307    FIRST VERSION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.PARAMETER

    IF VAL.TEXT THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN

*----
INIT:
*----

    LREF.APP = 'TELLER.PARAMETER'
    LREF.FIELDS = 'L.TT.DESGN':@VM:'L.TT.LIMIT.CCY':@VM:'L.TT.LIMIT.AMT'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.TT.DESGN.POS = LREF.POS<1,1>
    L.TT.LIMIT.CCY.POS = LREF.POS<1,2>
    L.TT.LIMIT.AMT.POS = LREF.POS<1,3>

RETURN

*-------
PROCESS:
*-------

    Y.DESGN.DATA = R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.DESGN.POS>
    Y.CCY.DATA = R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.LIMIT.CCY.POS>
    Y.AMT.DATA = R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.LIMIT.AMT.POS>

    Y.TOT.DESGN = DCOUNT(Y.DESGN.DATA,@SM)

    Y.STOP = 'N'
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.DESGN
        Y.DESGN = FIELD(Y.DESGN.DATA,@SM,Y.CNT)
        Y.CCY = FIELD(Y.CCY.DATA,@SM,Y.CNT)
        Y.AMT = FIELD(Y.AMT.DATA,@SM,Y.CNT)
        GOSUB VAL.PARAM.NULL
        IF Y.STOP EQ 'Y' THEN
            Y.CNT = Y.TOT.DESGN + 1
        END ELSE
            Y.CNT += 1 ;*AUTO R22 CODE CONVERSION
        END
    REPEAT

RETURN

*--------------
VAL.PARAM.NULL:
*--------------

    IF Y.DESGN EQ '' THEN
        AV = L.TT.DESGN.POS
        GOSUB GET.ERROR
    END

    IF Y.CCY EQ '' THEN
        AV = L.TT.LIMIT.CCY.POS
        GOSUB GET.ERROR
    END

    IF Y.AMT EQ '' THEN
        AV = L.TT.LIMIT.AMT.POS
        GOSUB GET.ERROR
    END

    IF Y.STOP EQ 'N' THEN
        GOSUB VAL.PARAM.DUP
    END

RETURN

*---------
GET.ERROR:
*---------

    Y.STOP = 'Y'
    AF = TT.PAR.LOCAL.REF
    AS = Y.CNT
    ETEXT = 'TT-REDO.TP.ROL.NULL'
    CALL STORE.END.ERROR

RETURN

*-------------
VAL.PARAM.DUP:
*-------------

    Y.CNT.2 = 1
    LOOP
    WHILE Y.CNT.2 LE Y.TOT.DESGN
        Y.DESGN.TO.COMP = FIELD(Y.DESGN.DATA,@SM,Y.CNT.2)
        Y.CCY.TO.COMP = FIELD(Y.CCY.DATA,@SM,Y.CNT.2)
        IF Y.DESGN EQ Y.DESGN.TO.COMP AND Y.CCY EQ Y.CCY.TO.COMP AND Y.CNT GT Y.CNT.2 THEN
            Y.CNT.2 = Y.TOT.DESGN + 1
            AF = TT.PAR.LOCAL.REF
            AV = L.TT.LIMIT.CCY.POS
            AS = Y.CNT
            ETEXT = 'TT-REDO.TP.CCY.DUP'
            CALL STORE.END.ERROR
        END ELSE
            Y.CNT.2 += 1 ;*AUTO R22 CODE CONVERSION
        END
    REPEAT

RETURN

END
