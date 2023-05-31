* @ValidationCode : MjoyMDgxNjQwOTcxOkNwMTI1MjoxNjgwNjAzODI5Mzk3OklUU1M6LTE6LTE6MTY0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:53:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 164
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.ENQ.NO.COLL.FS(DATA.OUT)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :ROUTINE TO NOFILE ENQUIRY
* Attached to     :TYPE.OF.SEC.FS DROPDOWN IN REDO.CREATE.ARRANGEMENT
* Attached as     :FILTER ROUTINE
* Primary Purpose :FILTER THE DATA THAT SHOW THIS DROPDOWN BY TYPE OF COLLATERAL*

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
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
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

    LOCATE "TYPE.OF.SEC.FS" IN D.FIELDS<1> SETTING PRO.POS THEN
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

RETURN
*

END
