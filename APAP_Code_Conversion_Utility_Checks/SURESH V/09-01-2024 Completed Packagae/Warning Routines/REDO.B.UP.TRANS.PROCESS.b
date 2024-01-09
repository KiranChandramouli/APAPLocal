* @ValidationCode : Mjo5MjA4MTk3MzpDcDEyNTI6MTY4NDg1NDM5OTk1NjpJVFNTOi0xOi0xOjEwMjk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1029
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UP.TRANS.PROCESS(BUILD.LIST)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.TRANS.PROCESS
* ODR           : ODR-2010-08-0031
*------------------------------------------------------------------------------------------
*DESCRIPTION  : REDO.B.TRANS.PROCESS Multithreading routine responsible for generates
*FUNDS.TRANSFER Record
*------------------------------------------------------------------------------------------
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------------------
* DATE             WHO                         REFERENCE            DESCRIPTION
*==============    ==============              =================    =================
* 19.10.2010       Sakthi Sellappillai         ODR-2010-08-0031     INITIAL CREATION
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_System
    $INSERT I_REDO.B.UP.TRANS.PROCESS.COMMON
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.REDO.ISSUE.MAIL
    $INSERT I_F.CUSTOMER

    GOSUB INITALISE
    GOSUB PROCESS
    GOSUB GOEND
RETURN

*------------------------------------------------------------------------------------------
INITALISE:
*------------------------------------------------------------------------------------------
    Y.RECORD.DETAILS = ''
    Y.FAIL.DR.FLAG = ''
    Y.FAIL.CR.FLAG = ''
    Y.SUCCESS.FLAG = ''
    Y.COMPLETE.FAILURE = ''
    Y.COMPLETE.FAILURE = ''
    Y.REC.STATUS = ''
    Y.REF.FILE.NAME = ''
    Y.SUCCESS.DETAILS = ''
    Y.FAIL.DETAILS = ''
*    CALL F.READ(FN.REDO.FILE.DATE.PROCESS,BUILD.LIST,R.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS,REDO.FILE.DATE.PROCESS.ERR)
    CALL F.READU(FN.REDO.FILE.DATE.PROCESS,BUILD.LIST,R.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS,REDO.FILE.DATE.PROCESS.ERR,'');* R22 UTILITY AUTO CONVERSION
    Y.SUPPLIER.PAY.LIST = R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.PAY.RECORD.ID>
    R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.MAIL.STATUS> = 'SENT'
    CALL F.WRITE(FN.REDO.FILE.DATE.PROCESS,BUILD.LIST,R.REDO.FILE.DATE.PROCESS)
    CHANGE @VM TO @FM IN Y.SUPPLIER.PAY.LIST

    Y.ID.PART1    = FIELD(BUILD.LIST,'.',1)
    Y.SECOND.PART = FIELD(BUILD.LIST,'.',3)
    Y.ID.PART2 = Y.SECOND.PART[1,13]
    Y.ID.PART3 = Y.SECOND.PART[14,3]
    Y.REF.FILE.NAME = Y.ID.PART1:'.':Y.ID.PART2:'.':Y.ID.PART3
RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------



    IF Y.SUPPLIER.PAY.LIST THEN
        Y.SUPPLIER.PAY.CNT = DCOUNT(Y.SUPPLIER.PAY.LIST,@FM)
        Y.SUP.PAY.INIT = 1
        LOOP
            Y.RECORD.DETAILS = '';Y.FAIL.CNT='';Y.SUCCESS.CNT='';
            REMOVE Y.SUPPLIER.PAY.ID FROM Y.SUPPLIER.PAY.LIST SETTING Y.OFS.MSG.POS
        WHILE Y.SUPPLIER.PAY.ID : Y.OFS.MSG.POS
            GOSUB PAYMENT.PROCESS

        REPEAT
    END
    BEGIN CASE
        CASE Y.FAIL.DR.FLAG EQ '' AND Y.FAIL.CR.FLAG EQ ''

            Y.COMPLETE.SUCCESS<-1> = 'ARCHIVO APLICADO :':Y.REF.FILE.NAME:'-':FIELD(Y.SUP.PAY.FILE.NAME,'.',6)
            Y.COMPLETE.SUCCESS<-1> = '---------------------------------------------------------------------------'
            Y.FOOTER.SUCCESS<-1> =  'TOTAL TRANSACCIONES ':': ':Y.SUPPLIER.PAY.CNT
            Y.MID.LINE = ''
            Y.RECORD.DETAILS =Y.COMPLETE.SUCCESS:@FM:Y.MID.LINE:@FM:Y.SUCCESS.FILES:@FM:Y.MID.LINE:@FM:Y.FOOTER.SUCCESS
        CASE (Y.FAIL.DR.FLAG NE '' OR Y.FAIL.CR.FLAG NE '') AND Y.SUCCESS.FLAG

            Y.FAIL.CNT  = DCOUNT(Y.FAIL.FILES,@FM)
            Y.COMPLETE.FAILURE<-1> = 'ARCHIVO RECHAZADO :':Y.REF.FILE.NAME:'-':FIELD(Y.SUP.PAY.FILE.NAME,'.',6)
            Y.COMPLETE.FAILURE<-1> = '---------------------------------------------------------------------------'
            Y.FOOTER.FAILURE<-1> = 'TOTAL TRANSACCIONES ':': ':Y.FAIL.CNT
            Y.FAIL.DETAILS = Y.COMPLETE.FAILURE:@FM:Y.FAIL.FILES:@FM:Y.FOOTER.FAILURE

            Y.SUCCESS.CNT = DCOUNT(Y.SUCCESS.FILES,@FM)
            Y.COMPLETE.SUCCESS<-1> = 'ARCHIVO APLICADO :':Y.REF.FILE.NAME:'-':FIELD(Y.SUP.PAY.FILE.NAME,'.',6)
            Y.COMPLETE.SUCCESS<-1> = '---------------------------------------------------------------------------'

            Y.FOOTER.SUCCESS<-1> =  'TOTAL TRANSACCIONES ':': ':Y.SUCCESS.CNT
            Y.SUCCESS.DETAILS = Y.COMPLETE.SUCCESS:@FM:Y.SUCCESS.FILES:@FM:Y.FOOTER.SUCCESS
            Y.MID.LINE  = '':@FM:'':@FM:''
            Y.RECORD.DETAILS = Y.FAIL.DETAILS:@FM:Y.MID.LINE:@FM:Y.SUCCESS.DETAILS


        CASE Y.FAIL.DR.FLAG NE ''
            Y.COMPLETE.FAILURE<-1> = 'ARCHIVO RECHAZADO :':Y.REF.FILE.NAME:'-':FIELD(Y.SUP.PAY.FILE.NAME,'.',6)
            Y.COMPLETE.FAILURE<-1> = '---------------------------------------------------------------------------'
            Y.FOOTER.FAILURE<-1> = 'TOTAL TRANSACCIONES ':': ':Y.SUPPLIER.PAY.CNT
            Y.MID.LINE = ''
            Y.RECORD.DETAILS =Y.COMPLETE.FAILURE:@FM:Y.MID.LINE:@FM:Y.FAIL.FILES:@FM:Y.MID.LINE:@FM:Y.FOOTER.FAILURE

        CASE Y.FAIL.CR.FLAG NE ''
            Y.COMPLETE.FAILURE<-1> = 'ARCHIVO RECHAZADO :':Y.REF.FILE.NAME:'-':FIELD(Y.SUP.PAY.FILE.NAME,'.',6)
            Y.COMPLETE.FAILURE<-1> = '---------------------------------------------------------------------------'
            Y.FOOTER.FAILURE<-1> = 'TOTAL TRANSACCIONES ':': ':Y.SUPPLIER.PAY.CNT
            Y.MID.LINE = ''
            Y.RECORD.DETAILS =Y.COMPLETE.FAILURE:@FM:Y.MID.LINE:@FM:Y.FAIL.FILES:@FM:Y.MID.LINE:@FM:Y.FOOTER.FAILURE
    END CASE




*  READ UPLOAD.DESC.DATA FROM F.REDO.EB.USER.PRINT.VAR,BUILD.LIST THEN ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,BUILD.LIST,UPLOAD.DESC.DATA,F.REDO.EB.USER.PRINT.VAR,UPLOAD.DESC.DATA.ERR)
    IF UPLOAD.DESC.DATA THEN  ;* Tus End
        Y.MAIL.DESCRIPTION = UPLOAD.DESC.DATA
    END

    Y.TRANS.DATE = TODAY
    Y.TRANS.TIME= OCONV(TIME(), "MT")
    CHANGE ":" TO '' IN Y.TRANS.TIME
    Y.UNIQUE.ID = Y.VAR.EXT.CUSTOMER:"_":Y.TRANS.DATE:"_":Y.TRANS.TIME
    Y.REQUEST.FILE = Y.UNIQUE.ID:'.TXT'
    Y.ATTACH.FILENAME = 'ATTACHMENT':'_':Y.UNIQUE.ID:'.TXT'
    R.RECORD1 = ''
    R.RECORD1 = Y.FROM.MAIL.ADD.VAL:"#":Y.TO.MAIL.VALUE:'#':Y.REF.FILE.NAME:'#':Y.MAIL.DESCRIPTION

    WRITE Y.RECORD.DETAILS  TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME

    WRITE R.RECORD1 TO F.HRMS.DET.FILE,Y.REQUEST.FILE




RETURN

*------------------------------------------------------------------------------------------
PAYMENT.PROCESS:
*------------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.SUPPLIER.PAYMENT,Y.SUPPLIER.PAY.ID,R.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT,Y.REDO.SUPPLIER.PAY.ERR)
    Y.SUP.PAY.BANK.CODE        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.CODE>
    IF Y.SUP.PAY.BANK.CODE THEN
        GOSUB SUPPLIER.PAY.PROCESS
    END ELSE
        GOSUB PAYROLL.PAY.PROCESS
    END
RETURN
*------------------------------------------------------------------------------------------
SUPPLIER.PAY.PROCESS:
*------------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.SUPPLIER.PAYMENT,Y.SUPPLIER.PAY.ID,R.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT,Y.REDO.SUPPLIER.PAY.ERR)
    Y.SUP.PAY.FILE.NAME        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.FILE.NAME>
    Y.SUP.PAY.SOURCE.ACCOUNT   =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.SOURCE.ACCOUNT>
    Y.SUP.PAY.PAYMENT.DATE     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.PAYMENT.DATE>
    Y.SUP.PAY.BANK.CODE        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.CODE>
    Y.SUP.PAY.BANK.NAME        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.NAME>
    Y.SUP.PAY.BEN.ACCOUNT      =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ACCOUNT>
    Y.SUP.PAY.IDENTIFY.TYPE    =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.IDENTIFY.TYPE>
    Y.SUP.PAY.BEN.ID.NO        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ID.NO>
    Y.SUP.PAY.BEN.CUSTOMER     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.CUSTOMER>
    Y.SUP.PAY.INVOICE.NO       =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.INVOICE.NO>
    Y.SUP.PAY.NCF.NO           =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.NCF.NO>
    Y.SUP.PAY.CURRENCY         =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.CURRENCY>
    Y.SUP.PAY.AMOUNT           =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.AMOUNT>
    Y.SUP.PAY.DR.STATUS        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.DR.STATUS>
    Y.SUP.PAY.CR.STATUS        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.CR.STATUS>
    Y.SUP.PAY.OFS.MSG.ID       = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.OFS.MESSAGE.ID>

    IF Y.SUP.PAY.OFS.MSG.ID THEN
        Y.SUP.PAY.OFS.RES.ID = Y.SUP.PAY.OFS.MSG.ID:'.1'
        CALL F.READ(FN.OFS.RESPONSE.QUEUE,Y.SUP.PAY.OFS.RES.ID,R.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE,Y.OFS.RES.ERR)
        IF R.OFS.RESPONSE.QUEUE THEN
            IF R.OFS.RESPONSE.QUEUE<1> EQ  1 THEN
            END ELSE
                Y.SUP.PAY.OFS.STATUS = R.OFS.RESPONSE.QUEUE<2>
            END
        END
    END

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.CUSTOMER = Y.SUP.PAY.FILE.NAME[".",1,1]
    CALL F.READU(FN.EB.EXTERNAL.USER,Y.VAR.EXT.CUSTOMER,R.EB.EXTERNAL.USER.REC,F.EB.EXTERNAL.USER,Y.EXT.USER.ERR,Y.EXT.USER.RETRY)
    IF R.EB.EXTERNAL.USER.REC THEN
        Y.REL.CUST.VAL = R.EB.EXTERNAL.USER.REC<EB.XU.CUSTOMER>
        Y.TO.MAIL.VALUE = R.EB.EXTERNAL.USER.REC<EB.XU.LOCAL.REF,Y.LOC.CORP.EMAIL.POS>
        R.EB.EXTERNAL.USER.REC = ''

    END

    R.RECORD.MAIL = ''
    R.RECORD.MAIL=Y.SUP.PAY.SOURCE.ACCOUNT:",":Y.SUP.PAY.BANK.CODE:",":Y.SUP.PAY.BANK.NAME:",":Y.SUP.PAY.BEN.ACCOUNT:",":
    R.RECORD.MAIL:=Y.SUP.PAY.IDENTIFY.TYPE:",":Y.SUP.PAY.BEN.ID.NO:",":Y.SUP.PAY.BEN.CUSTOMER:",":Y.SUP.PAY.INVOICE.NO:",":Y.SUP.PAY.NCF.NO:",":
    R.RECORD.MAIL:=Y.SUP.PAY.CURRENCY:",":Y.SUP.PAY.AMOUNT:

    BEGIN CASE
        CASE Y.SUP.PAY.DR.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.DR.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.DR.FLAG  = 1
        CASE Y.SUP.PAY.CR.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.CR.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.CR.FLAG = 1

        CASE Y.SUP.PAY.OFS.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.OFS.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.CR.FLAG = 1
        CASE 1
            Y.REC.STATUS = ",":"{Transaccisn exitosa}"
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.SUCCESS.FILES<-1> = R.RECORD.MAIL
            Y.SUCCESS.FLAG = 1
    END CASE

RETURN
*------------------------------------------------------------------------------------------
PAYROLL.PAY.PROCESS:
*------------------------------------------------------------------------------------------
    Y.SUP.PAY.FILE.NAME        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.FILE.NAME>
    Y.SUP.PAY.SOURCE.ACCOUNT   =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.SOURCE.ACCOUNT>
    Y.SUP.PAY.PAYMENT.DATE     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.PAYMENT.DATE>
    Y.SUP.PAY.BEN.ACCOUNT      =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ACCOUNT>
    Y.SUP.PAY.IDENTIFY.TYPE    =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.IDENTIFY.TYPE>
    Y.SUP.PAY.BEN.ID.NO        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ID.NO>
    Y.SUP.PAY.BEN.CUSTOMER     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.CUSTOMER>
    Y.SUP.PAY.CURRENCY         =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.CURRENCY>
    Y.SUP.PAY.AMOUNT           =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.AMOUNT>
    Y.SUP.PAY.DR.STATUS        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.DR.STATUS>
    Y.SUP.PAY.CR.STATUS        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.CR.STATUS>
    Y.SUP.PAY.OFS.MSG.ID       = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.OFS.MESSAGE.ID>

    IF Y.SUP.PAY.OFS.MSG.ID THEN
        Y.SUP.PAY.OFS.RES.ID = Y.SUP.PAY.OFS.MSG.ID:'.1'
        CALL F.READ(FN.OFS.RESPONSE.QUEUE,Y.SUP.PAY.OFS.RES.ID,R.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE,Y.OFS.RES.ERR)
        IF R.OFS.RESPONSE.QUEUE THEN
            IF R.OFS.RESPONSE.QUEUE<1> EQ  1 THEN
            END ELSE
                Y.SUP.PAY.OFS.STATUS = R.OFS.RESPONSE.QUEUE<2>
                Y.PAY.SUP.PAY.STRING = 'TRANSACTION FAILURE'
            END
        END
    END

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.CUSTOMER = Y.SUP.PAY.FILE.NAME[".",1,1]
    CALL F.READU(FN.EB.EXTERNAL.USER,Y.VAR.EXT.CUSTOMER,R.EB.EXTERNAL.USER.REC,F.EB.EXTERNAL.USER,Y.EXT.USER.ERR,Y.EXT.USER.RETRY)
    IF R.EB.EXTERNAL.USER.REC THEN
        Y.REL.CUST.VAL  = R.EB.EXTERNAL.USER.REC<EB.XU.CUSTOMER>
        Y.TO.MAIL.VALUE = R.EB.EXTERNAL.USER.REC<EB.XU.LOCAL.REF,Y.LOC.CORP.EMAIL.POS>
        R.EB.EXTERNAL.USER.REC = ''
    END

    R.RECORD.MAIL = ''
    R.RECORD.MAIL = Y.SUP.PAY.SOURCE.ACCOUNT:",":Y.SUP.PAY.BEN.ACCOUNT:",":
    R.RECORD.MAIL:=Y.SUP.PAY.IDENTIFY.TYPE:",":Y.SUP.PAY.BEN.ID.NO:",":Y.SUP.PAY.BEN.CUSTOMER:",":
    R.RECORD.MAIL:=Y.SUP.PAY.CURRENCY:",":Y.SUP.PAY.AMOUNT

    BEGIN CASE
        CASE Y.SUP.PAY.DR.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.DR.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.DR.FLAG  = 1
        CASE Y.SUP.PAY.CR.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.CR.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.CR.FLAG = 1
        CASE Y.SUP.PAY.OFS.STATUS NE ''
            Y.REC.STATUS = ",":Y.SUP.PAY.OFS.STATUS
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.FAIL.FILES<-1> = R.RECORD.MAIL
            Y.FAIL.CR.FLAG = 1
        CASE 1
            Y.REC.STATUS = ",":"{Transaccisn exitosa}"
            R.RECORD.MAIL = R.RECORD.MAIL:Y.REC.STATUS
            Y.SUCCESS.FILES<-1> = R.RECORD.MAIL
            Y.SUCCESS.FLAG = 1
    END CASE
RETURN
*------------------------------------------------------------------------------------------
GOEND:
*------------------------------------------------------------------------------------------
END
*--------------------------------*END OF SUBROUTINE*---------------------------------------
