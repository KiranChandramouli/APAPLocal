SUBROUTINE REDO.NOFILE.TYPE.COLL(AC.DETAILS)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :Routine to  Nofile Enquiry
* Attached to     :
* Attached as     :Build routine that
* Primary Purpose :Get information for COLLATERAL.TYPE
*
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa(pdelarosa@temenos.com) - TAM Latin America
* Date            : September 10 2012
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.TYPE
*************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

* ======
PROCESS:
* ======

    AC.DETAILS = ''
*GET THE ID FOR ENTITY(ENTIDAD)
    VAR.COLL.CODE = R.NEW(COLL.COLLATERAL.CODE);

* GET THE 2 FIRTS NUMBER FROM CODE
    VAR.AUX  = SUBSTRINGS (VAR.COLL.CODE,1,2)


* Read the lis of valuators
    SELECT.STATEMENT = 'SELECT ':FN.COLLATERAL.TYPE : " WITH @ID LIKE  ": VAR.AUX :"..."
    LOCK.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*Get the data that view in the list
    LOOP
        REMOVE Y.ID.AA.PRD FROM LOCK.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS


*CALL F.READ (FN.COLLATERAL.TYPE,Y.ID.AA.PRD,R.CUA,F.CUA.PC,Y.CUA.ERR)

        CALL CACHE.READ(FN.COLLATERAL.TYPE, Y.ID.AA.PRD, R.CUA, Y.ERR)

        AC.DETAILS<-1>=Y.ID.AA.PRD:"*":R.CUA<1>

    REPEAT
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)

RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1

    FN.COLLATERAL.TYPE = "F.COLLATERAL.TYPE"
    F.COLLATERAL.TYPE  = ""

*Inicialice Vars for get information
    F.CUA.PC  = ''
    R.CUA     = ''
    Y.CUA.ERR = ''

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

RETURN
END
