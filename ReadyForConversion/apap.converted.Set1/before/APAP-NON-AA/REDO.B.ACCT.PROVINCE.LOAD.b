*-----------------------------------------------------------------------------
* <Rating>-70</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.PROVINCE.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT TAM.BP I_REDO.B.ACCT.PROVINCE.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

    RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------

    FN.RE.CRF.MBGL = 'F.RE.CRF.MBGL'
    F.RE.CRF.MBGL = ''
    CALL OPF(FN.RE.CRF.MBGL,F.RE.CRF.MBGL)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.COMPANY = 'F.COMPANY'; FV.COMPANY = ''
    CALL OPF(FN.COMPANY,FV.COMPANY)
    RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------

    GOSUB GET.PARAM.DETAILS
    GOSUB GET.CO.CODES
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
    RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        CALL ALLOCATE.UNIQUE.TIME(Y.TIME)
        FILENAME = FILE.NAME:".TEMP.":SESSION.NO:".":SERVER.NAME
    END
    RETURN
*---------------------------------------------------------------------------------
GET.CO.CODES:
*------------
    LOCATE 'CO.CODES.01' IN FIELD.NAME<1,1> SETTING CO.FOUND.POS THEN
        Y.CO.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CO.FOUND.POS>
        Y.CO.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,CO.FOUND.POS>
    END

    LOCATE 'REGION' IN FIELD.NAME<1,1> SETTING REG.FOUND.POS THEN
        Y.REG.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG.FOUND.POS>
        Y.REG.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG.FOUND.POS>
    END

    LOCATE 'REGION1' IN FIELD.NAME<1,1> SETTING R1.FOUND.POS THEN
        Y.R1.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R1.FOUND.POS>
        Y.R1.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R1.FOUND.POS>
    END

    LOCATE 'REGION2' IN FIELD.NAME<1,1> SETTING R2.FOUND.POS THEN
        Y.R2.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R2.FOUND.POS>
        Y.R2.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R2.FOUND.POS>
    END

    LOCATE 'REGION3' IN FIELD.NAME<1,1> SETTING R3.FOUND.POS THEN
        Y.R3.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R3.FOUND.POS>
        Y.R3.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R3.FOUND.POS>
    END

    LOCATE 'COLUMN' IN FIELD.NAME<1,1> SETTING COL.POS THEN
        Y.COLUMN.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,COL.POS>
        CHANGE SM TO FM IN Y.COLUMN.ID
    END
    RETURN

OPEN.TEMP.PATH:
*--------------
    SEQ.PTR = ''
    IF TEMP.PATH THEN
        OPEN TEMP.PATH TO TEMP.PATH1 ELSE
                Y.PATH = TEMP.PATH
                GOSUB RAISE.ERR.C.22
        END
    END ELSE
        Y.PATH = 'Temp Path Missing In Parameter file'
        GOSUB RAISE.ERR.C.22
    END

    IF OUT.PATH THEN
        OPEN OUT.PATH TO OUT.PATH1 ELSE
                Y.PATH = OUT.PATH
                GOSUB RAISE.ERR.C.22
        END
    END ELSE
        Y.PATH = 'Out Path Missing In Parameter file'
        GOSUB RAISE.ERR.C.22
    END
    RETURN
*---------------------------------------------------------------------------------
RAISE.ERR.C.22:
*--------------
*
    ERR.MSG = "Unable to open '":Y.PATH:"'"
    INT.CODE = "REP001"
    INT.TYPE = "ONLINE"
    MON.TP = "04"
    REC.CON = "PROVINCE-":ERR.MSG
    DESC = "PROVINCE-":ERR.MSG
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.LOCALIDAD'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.LOCALIDAD.POS = Y.POS<1,1>
    RETURN
END
