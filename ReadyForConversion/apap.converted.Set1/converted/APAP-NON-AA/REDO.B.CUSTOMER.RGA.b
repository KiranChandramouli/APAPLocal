SUBROUTINE REDO.B.CUSTOMER.RGA(CUSTOMER.ID)
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
* Description:
*-------------------------------------------------------------------------------
* Modification History
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.B.CUSTOMER.RGA.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON

    R.CUSTOMER = ''; CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.GRP.RIESGO = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>

    IF R.CUSTOMER NE '' AND Y.GRP.RIESGO NE '' THEN
        Y.CUSTOMER.ID   = CUSTOMER.ID
        Y.PRODUCT.GROUP = ''
        Y.REL.CODE      = ''
        OUT.ARR         = ''

        CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
        GOSUB GET.COURT.DATE
        GOSUB GET.CUSTOMER.CODE
        GOSUB GET.COMPANY.DECTOR
        GOSUB GET.NAME.INITIAL
        CHANGE @SM TO @FM IN Y.GRP.RIESGO
        Y.GRP.RIESGO.MAX=DCOUNT(Y.GRP.RIESGO,@FM)

        Y.GRP.RIESGO.CNT=1
        LOOP
        WHILE Y.GRP.RIESGO.CNT LE Y.GRP.RIESGO.MAX
            C$SPARE(455)=Y.GRP.RIESGO<Y.GRP.RIESGO.CNT>[4,7]
            GOSUB MAP.RCL.RECORD
            Y.GRP.RIESGO.CNT += 1
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------
GET.COURT.DATE:
*--------------

    Y.D = "-1C"
    Y.LST.CDAY = TODAY
    Y.LST.CDAY =Y.LST.CDAY[1,6]:'01'
    CALL CDT('',Y.LST.CDAY,Y.D)

    Y.COURT.DT     =Y.LST.CDAY[7,2]:'/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]
    C$SPARE(451)   = Y.COURT.DT
RETURN
*-------------------------------------------------------------------------
GET.CUSTOMER.CODE:
*-----------------
    Y.CUST.CODE    = FIELD(OUT.ARR,@FM,1)
    C$SPARE(452)   = Y.CUST.CODE
RETURN
*--------------------------------------------------------------------------------
GET.COMPANY.DECTOR:
*------------------
    Y.COMP.DEBTOR  = FIELD(OUT.ARR,@FM,3)
    C$SPARE(453)   = Y.COMP.DEBTOR
RETURN
*------------------------------------------------------------------------------
GET.NAME.INITIAL:
*----------------
    Y.NAME.INITIAL = FIELD(OUT.ARR,@FM,4)
    C$SPARE(454)   = Y.NAME.INITIAL
RETURN
*------------------------------------------------------------------------------
MAP.RCL.RECORD:
*--------------
    MAP.FMT = 'MAP'
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP = FN.CUSTOMER
    ID.APP = CUSTOMER.ID
    R.APP = R.CUSTOMER
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG
    GOSUB WRITE.TO.FILE
RETURN
*--------------------------------------------------------------------------------
WRITE.TO.FILE:
*--------------
    WRITESEQ OUT.ARRAY ON SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":FILE.NAME
        INT.CODE = "R15"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "R15-":ERR.MSG
        DESC = "R15-":ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
RETURN
*--------------------------------------------------------------------------
END
