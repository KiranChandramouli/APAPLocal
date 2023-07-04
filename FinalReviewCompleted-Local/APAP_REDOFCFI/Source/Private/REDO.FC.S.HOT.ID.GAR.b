* @ValidationCode : MjotMjk1MDYzNTc0OkNwMTI1MjoxNjgwNzgzNjY4MTU4OklUU1M6LTE6LTE6LTM3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -37
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.HOT.ID.GAR
*
* ====================================================================================
*
*

* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:
* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======



    CALL System.setVariable("CURRENT.Y.AMOUNT",Y.AMOUNT)
    CALL System.setVariable("CURRENT.Y.ID.TITULAR.GAR",Y.ID.TITULA.GARANTIA)
    CALL System.setVariable("CURRENT.Y.CURRENCY",Y.CURRENCY)

RETURN
*
* =========
OPEN.FILES:
* =========
*

RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1

    Y.AMOUNT=R.NEW(REDO.FC.AMOUNT)

    Y.CURRENCY= R.NEW(REDO.FC.LOAN.CURRENCY)

    Y.ID.TITULA.GARANTIA = COMI

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*


*
RETURN
*

END
