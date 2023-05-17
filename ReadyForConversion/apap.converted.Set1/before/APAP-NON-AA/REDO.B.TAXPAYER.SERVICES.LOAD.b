*------------------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.TAXPAYER.SERVICES.LOAD
*------------------------------------------------------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/REDO.B.TAXPAYER.SERVICES
*
* Attached As           : Online Batch Routine to COB
*--------------------------------------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*--------------------------------------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
*--------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.TAXPAYER.SERVICES.COMMON
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT T24.BP I_BATCH.FILES
*    $INSERT T24.BP I_BATCH
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.DATES
    $INSERT RAD.BP I_F.RAD.CONDUIT.LINEAR
    $INSERT TAM.BP I_F.REDO.NCF.ISSUED
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
*
    GOSUB INITIALISE
*
    RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
INITIALISE:
*----------
*Initialize all the files and varibles
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
*
    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
*
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
*
    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS  = ''
*
    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED = ''
*
    FN.RAD.CONDUIT.LINEAR = 'F.RAD.CONDUIT.LINEAR'
    F.RAD.CONDUIT.LINEAR  = ''
    FN.CUSTOMER.HST = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HST  = ''
*
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)
    CALL OPF(FN.RAD.CONDUIT.LINEAR,F.RAD.CONDUIT.LINEAR)
    CALL OPF(FN.CUSTOMER.HST,F.CUSTOMER.HST)

    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)
*
    Y.APP = "CUSTOMER":FM:"FUNDS.TRANSFER"
    Y.FIELDS = "L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.FOREIGN":FM:"ITBIS.COM.VAL"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    Y.CIDENT.POS = Y.FIELD.POS<1,1>
    Y.RNC.POS    = Y.FIELD.POS<1,2>
    Y.FORE.POS   = Y.FIELD.POS<1,3>
    Y.ITBIS.POS  = Y.FIELD.POS<2,1>
*
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.PARAM.ID = "REDO.REGN9"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.ID    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.DATE.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.YEAR.MONTH>
        Y.FREQ.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FREQUENCY.REQ>
        BEGIN CASE
        CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Yearly'
            Y.DATE.REQ = Y.DATE.REQ[1,4]
        CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Monthly'
            Y.DATE.REQ = Y.DATE.REQ[1,6]
        CASE Y.FREQ.REQ EQ 'Yearly'
            Y.DATE.REQ = Y.LAST.DAY[1,4]
        CASE (Y.FREQ.REQ EQ 'Monthly') OR Y.FREQ.REQ EQ ''
            Y.DATE.REQ = Y.LAST.DAY[1,6]
        END CASE
    END
*
    Y.FILE.NAME = Y.FILE.ID:".TEMP.":SESSION.NO:".":SERVER.NAME
    CHANGE VM TO '' IN Y.FILE.DIR
*
    Y.RCL.ID = "REDO.RCL.REGN9.HR"
    CALL F.READ(FN.RAD.CONDUIT.LINEAR,Y.RCL.ID,R.RAD.CONDUIT.LINEAR,F.RAD.CONDUIT.LINEAR,Y.ERR)
*
    IF R.RAD.CONDUIT.LINEAR NE '' THEN
        Y.RCL.IN.POS     = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.IN.POSITION>
        Y.RCL.CONV.FUNC  = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.CONV.FUNC>
        Y.RCL.CONV.PARAM = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.CONV.PARAM>
*
        LOCATE 'APAP.ID' IN Y.RCL.IN.POS<1,1> SETTING ID.POS THEN
            Y.RCL.APAP.ID = Y.RCL.CONV.PARAM<1,ID.POS>
        END
    END
*
    OPENSEQ Y.FILE.DIR,Y.FILE.NAME TO SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*----------------------
*
    MON.TP    = "13"
    REC.CON   = "REGN9-":Y.ERR.MSG
    DESC      = "REGN9-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*
*--------------------------------------------------------------------------------------------------------------------------------------------
END
*--------------------------------------------------------------------------------------------------------------------------------------------
