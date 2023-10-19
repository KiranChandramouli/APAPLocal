* @ValidationCode : MjoxMzI4NjM1OTc5OkNwMTI1MjoxNjgyNDIxMDMyNjU4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:40:32
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
SUBROUTINE REDO.FC.S.SET.LIMIT

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Setting the values for LIMIT
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 06 Julio 2011
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*======================

* Get Limit Product for the given Category Code

* Set Limit information
*****************************************************

    R.NEW(REDO.FC.LIMIT.CURRENCY) = R.NEW(REDO.FC.LOAN.CURRENCY)
    R.NEW(REDO.FC.APPROVAL.DATE) = R.NEW(REDO.FC.EFFECT.DATE)
    R.NEW(REDO.FC.OFFERED.UNTIL) = R.NEW(REDO.FC.EFFECT.DATE)

    Y.MAT.DATE = R.NEW(REDO.FC.TERM)
    CALL CALENDAR.DAY(R.NEW(REDO.FC.EFFECT.DATE),'+',Y.MAT.DATE)

    R.NEW(REDO.FC.EXPIRY.DATE)       = Y.MAT.DATE
    IF OFS$BROWSER THEN
        R.NEW(REDO.FC.NOTES)             = "CREADO POR VERSION MANUAL"
    END
    ELSE
        R.NEW(REDO.FC.NOTES)             = "CREADO POR FABRICA DE CREDITO"
    END
    R.NEW(REDO.FC.INTERNAL.AMOUNT)   = R.NEW(REDO.FC.AMOUNT)
    R.NEW(REDO.FC.MAXIMUM.TOTAL)     = R.NEW(REDO.FC.INTERNAL.AMOUNT)
    R.NEW(REDO.FC.AVAILABLE.MARKER)  = "Y"
    R.NEW(REDO.FC.MAXIMUM.SECURED) = R.NEW(REDO.FC.AMOUNT)
    R.NEW(REDO.FC.REVIEW.FREQUENCY) = Y.MAT.DATE
    R.NEW(REDO.FC.PROPO.SAL.DATE) = R.NEW(REDO.FC.EFFECT.DATE)
    R.NEW(REDO.FC.ONLINE.LIMIT.DATE) = TODAY
    R.NEW(REDO.FC.FIXED.VARIABLE) = 'FIXED'

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------------

END
