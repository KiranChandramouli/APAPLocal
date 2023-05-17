*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CUSTOMER.RGA.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date       Author              Modification Description
*
* 05/02/2015  Ashokkumar.V.P        PACS00368383 - New mapping changes
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.CUSTOMER.RGA.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INCLUDE TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
*

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
*
    RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    Y.FLAG = 1
    RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
    RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME = FILE.NAME:".TEMP.":SESSION.NO:".":SERVER.NAME
    END
    RETURN
*---------------------------------------------------------------------------------
OPEN.TEMP.PATH:
*--------------
    OPENSEQ TEMP.PATH,FILENAME TO SEQ.PTR ELSE
        CREATE SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "R15"
            INT.TYPE = "ONLINE"
            MON.TP = "02"
            REC.CON = "R15-":ERR.MSG
            DESC = "R15-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
    RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
*
    Y.POS = ''
    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.FOREIGN':VM:'L.CU.TIPO.CL':VM:'L.CU.GRP.RIESGO'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.CU.CIDENT.POS = Y.POS<1,1>
    L.CU.RNC.POS = Y.POS<1,2>
    L.CU.FOREIGN.POS = Y.POS<1,3>
    L.CU.TIPO.CL.POS = Y.POS<1,4>
    L.CU.GRP.RIESGO.POS = Y.POS<1,5>
    RETURN
*----------------------------------------------------------------------
END
