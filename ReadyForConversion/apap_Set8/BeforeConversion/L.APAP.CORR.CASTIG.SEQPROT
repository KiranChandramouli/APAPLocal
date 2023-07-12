*-----------------------------------------------------------------------------
* <Rating>819</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.CORR.CASTIG.SEQPROT(AA.ARR.ID)
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to adjust the Insurance (SEGPROTFIN1) amount for the castigado prestamos.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.BALANCE.MAINTENANCE
    $INSERT I_L.APAP.CORR.CASTIG.SEQPROT.COMMON

    ArrangementID = AA.ARR.ID
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''; Y.LOAN.STATUS = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    Y.LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,L.LOAN.STATUS.1.POSN>
    YCO.CODE = R.AA.OVERDUE<AA.OD.CO.CODE>

    IF Y.LOAN.STATUS NE "Write-off" THEN
        CRT "Loan is not Castigado"
        RETURN
    END

    ERR.AA.ARRANGEMENT = ''; R.AA.ARRANGEMENT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARRANGEMENT)

    ERR.AA.ACCOUNT.DETAILS = ''; R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
    Y.BIL.IDS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BIL.IDS = CHANGE(Y.BIL.IDS,SM,FM)
    Y.BIL.IDS = CHANGE(Y.BIL.IDS,VM,FM)
    YBILL.CNT = 0;  YBILL.CNT = DCOUNT(Y.BIL.IDS,FM)
    CUST.ID = ''

    LOOP
        REMOVE AABILL.ID FROM Y.BIL.IDS SETTING BIL.POSN
    WHILE AABILL.ID:BIL.POSN

        ERR.AA.BILL.DETAILS = ''; R.AA.BILL.DETAILS = ''
        CALL F.READ(FN.AA.BILL.DETAILS,AABILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,ERR.AA.BILL.DETAILS)

        IF R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1> EQ 'UNPAID' THEN
            FINDSTR 'SEGPROTFIN1' IN R.AA.BILL.DETAILS<AA.BD.PROPERTY> SETTING VLPOSN,VSMPOSN,VVMPOSN THEN

                YINS.AMT = ''; YINS.AMT = R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT,VLPOSN>
                IF YINS.AMT EQ 0 THEN CONTINUE
                IF YINS.AMT EQ '' THEN CONTINUE

                ArrangementID = AA.ARR.ID
                idPropertyClass = 'BALANCE.MAINTENANCE'
                idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''; R.AA.BALANCE.MAINTENANCE = ''
                CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
                R.AA.BALANCE.MAINTENANCE = RAISE(returnConditions)
                IF R.AA.BALANCE.MAINTENANCE<AA.BM.ACTIVITY> EQ 'LENDING-RENEGOTIATE-CANCEL' THEN
                    YID.DATE = ''; YID.DATE = R.AA.BALANCE.MAINTENANCE<AA.BM.ID.COMP.3>
                    YID.DATE = FIELD(YID.DATE,'.',1)
                    CALL CDT('',YID.DATE,'-1C')
                    ArrangementID = AA.ARR.ID
                    idPropertyClass = 'BALANCE.MAINTENANCE'
                    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = YID.DATE; R.AA.BALANCE.MAINTENANCE = ''
                    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
                    R.AA.BALANCE.MAINTENANCE = RAISE(returnConditions)
                END

                YBILL.REF = ''; YBILL.REF = R.AA.BALANCE.MAINTENANCE<AA.BM.BILL.REF>

                YBAL.PROP = ''; YBAL.PROP.AMT = ''
                FINDSTR AABILL.ID IN YBILL.REF SETTING BALB.POSN,BALSM.POSN,BALVM.POSN THEN
                    YBAL.PROP = R.AA.BALANCE.MAINTENANCE<AA.BM.PROPERTY,BALSM.POSN>
                    FINDSTR 'SEGPROTFIN1' IN YBAL.PROP SETTING INS.POSN,INSSM.POSN,INSVM.POSN THEN
                        YBAL.PROP.AMT = R.AA.BALANCE.MAINTENANCE<AA.BM.OS.PROP.AMT,BALSM.POSN,INSVM.POSN>

                        YINV.AMT = 0 ; YINV.AMT = YBAL.PROP.AMT * (-1)
                        SAVE.ID.COMPANY = ID.COMPANY
                        CALL LOAD.COMPANY(R.AA.ARRANGEMENT<AA.ARR.CO.CODE>)

                        options<1> = "AA.CORR"
                        theResponse = ""; txnCommitted = ""
                        OFS.RECORD = "AA.ARRANGEMENT.ACTIVITY,TEST/I/PROCESS//0/,//":ID.COMPANY:"/////,,ARRANGEMENT:1:1=":AA.ARR.ID:",ACTIVITY:1:1=LENDING-ADJUST.BILL-MANT.SALD.CUOTA,PROPERTY:1:1=MANT.SALD.CUOTA,FIELD.NAME:1:1=ADJ.PROP.AMT:":BALSM.POSN:":":INSVM.POSN:",FIELD.VALUE:1:1=":YINV.AMT
                        CRT OFS.RECORD
                        CALL OFS.CALL.BULK.MANAGER(options, OFS.RECORD, theResponse, txnCommitted)
                        CALL LOAD.COMPANY(SAVE.ID.COMPANY)
                        CRT theResponse
                        IF txnCommitted EQ "1" THEN
                            CUST.ID<-1> = AA.ARR.ID:',':AABILL.ID:',':YBAL.PROP.AMT
                        END
                    END
                END
            END
        END
    REPEAT

    IF CUST.ID THEN
        Y.FILE.ID='AK_CASTIGADO.':AA.ARR.ID:SESSION.NO
        FN.SAVE.LIST = '&SAVEDLISTS&'
        F.SAVE.LIST = ''
        CALL OPF(FN.SAVE.LIST,F.SAVE.LIST)
        WRITE CUST.ID TO F.SAVE.LIST, Y.FILE.ID
    END
    RETURN
END
