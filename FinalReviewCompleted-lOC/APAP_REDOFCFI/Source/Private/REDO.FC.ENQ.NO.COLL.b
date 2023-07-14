* @ValidationCode : MjotNjMwMTcwMDQ6Q3AxMjUyOjE2ODA2NzE1NjM5MjI6SVRTUzotMTotMToxNjM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:42:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 163
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.ENQ.NO.COLL(DATA.OUT)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :ROUTINE TO NOFILE ENQUIRY
* Attached to     :TYPE.OF.SEC.BR DROPDOWN IN REDO.CREATE.ARRANGEMENT
* Attached as     :FILTER ROUTINE
* Primary Purpose :FILTER THE DATA THAT SHOW THIS DROPDOWN BY TYPE OF COLLATERAL
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
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 29 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.COLLATERAL.TYPE

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

    LOCATE "TYPE.OF.SEC.BR" IN D.FIELDS<1> SETTING PRO.POS THEN
        Y.TYPE.COLL=D.RANGE.AND.VALUE<PRO.POS>
    END


    SELECT.STATEMENT = "SELECT ":FN.COLLATERAL:" WITH COLLATERAL.CODE EQ '": Y.TYPE.COLL:"'"

    Y.REDO.LOAN.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.TYPE.PRODUCT = ''
    CALL EB.READLIST(SELECT.STATEMENT,Y.REDO.LOAN.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)


    LOOP
        REMOVE Y.COLL.ID FROM Y.REDO.LOAN.LIST SETTING POS
    WHILE Y.COLL.ID:POS
        CALL CACHE.READ(FN.COLLATERAL, Y.COLL.ID, R.COLLATERAL, Y.ERR)
        Y.ID.COLL.TYPE=R.COLLATERAL<COLL.COLLATERAL.TYPE>
        CALL CACHE.READ(FN.COLLATERAL.TYPE, Y.ID.COLL.TYPE, R.COLLATERAL.TYPE, Y.ERR)
        Y.ID.COLL.TYPE.DESC=R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>
        DATA.OUT<-1>=Y.COLL.ID:"*":Y.ID.COLL.TYPE.DESC


    REPEAT


RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)

RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1

    FN.COLLATERAL="F.COLLATERAL"
    F.COLLATERAL=""

    FN.COLLATERAL.TYPE="F.COLLATERAL.TYPE"
    F.COLLATERAL.TYPE=""
RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
