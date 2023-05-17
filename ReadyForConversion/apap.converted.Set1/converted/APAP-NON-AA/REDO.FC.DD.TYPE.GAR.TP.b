SUBROUTINE REDO.FC.DD.TYPE.GAR.TP(DATA.OUT)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :ROUTINE TO NOFILE ENQUIRY
* Attached to     :REDO.FC.SEC.CLASSIFY.TP DROPDOWN IN REDO.CREATE.ARRANGEMENT
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 27 2011
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL.CODE
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
* ======
PROCESS:
* ======

    LOCATE "TYPE.OF.SEC.TP" IN D.FIELDS<1> SETTING PRO.POS THEN
        Y.TYPE.COLL=D.RANGE.AND.VALUE<PRO.POS>
    END

    CALL CACHE.READ(FN.COLLATERAL.CODE, Y.TYPE.COLL, R.COLLATERAL.CODE, Y.ERR)

    IF R.COLLATERAL.CODE THEN
        Y.CLASE.COLL=  R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
        LOOP
            REMOVE Y.CLASE.COLL.ID FROM Y.CLASE.COLL SETTING POS
        WHILE Y.CLASE.COLL.ID:POS

            CALL CACHE.READ(FN.COLLATERAL.TYPE, Y.CLASE.COLL.ID, R.COLLATERAL.TYPE, Y.ERR)
            Y.ID.COLL.TYPE=R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>
            DATA.OUT<-1>=Y.CLASE.COLL.ID:"*":Y.ID.COLL.TYPE


        REPEAT
    END

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE)
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

    FN.COLLATERAL.CODE="F.COLLATERAL.CODE"
    F.COLLATERAL.CODE=""
    FN.COLLATERAL.TYPE="F.COLLATERAL.TYPE"
    F.COLLATERAL.TYPE=""


RETURN



* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

*
RETURN
*

END
