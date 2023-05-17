SUBROUTINE NOFILE.TYPE.INSTRU(AC.DETAILS)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :Routine to  Nofile Enquiry
* Attached to     :NOFILE.TYPE.INSTRU
* Attached as     :Build routine that
* Primary Purpose :Put de Description of the instrument of REDO.INSTRUMENT.TYPE in O.DATA to enquiry
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
* Date            : January 20 2011
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.ISSUE.ENTITY
    $INSERT I_F.REDO.INSTRUMENT.TYPE

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
    Y.ENTY.ID  = R.NEW(COLL.LOCAL.REF)<1,WPOS.ENTIDAD>

    CALL OPF(FN.REDO.INSTRUMENT.TYPE,F.REDO.INSTRUMENT.TYPE)

* Read the lis of valuators
    SELECT.STATEMENT = 'SELECT ':FN.REDO.INSTRUMENT.TYPE : " WITH @ID LIKE  ": Y.ENTY.ID :"..."
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


        CALL F.READ (FN.REDO.INSTRUMENT.TYPE,Y.ID.AA.PRD,R.CUA,F.CUA.PC,Y.CUA.ERR)

        AC.DETAILS<-1>=Y.ID.AA.PRD:"*":R.CUA<1>

    REPEAT
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.ISSUE.ENTITY,F.REDO.ISSUE.ENTITY)
    CALL OPF(FN.REDO.INSTRUMENT.TYPE,F.REDO.INSTRUMENT.TYPE)
    CALL OPF(FN.COLLATERAL,F.CUA.PC)
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
    WCAMPO    = "L.COL.ENTY.INS"
    WCAMPO<2> = "L.COL.ISS.ENTY"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.NOMBRE   = YPOS<1,1>
    WPOS.ENTIDAD  = YPOS<1,2>


    VAR.CLASE1 = R.NEW(COLL.LOCAL.REF)<1,WPOS.ENTIDAD>

    FN.REDO.ISSUE.ENTITY="F.REDO.ISSUE.ENTITY"
    F.REDO.ISSUE.ENTITY=""

    FN.REDO.INSTRUMENT.TYPE="F.REDO.INSTRUMENT.TYPE"
    F.REDO.INSTRUMENT.TYPE=""

    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''

*Inicialice Vars for open
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
