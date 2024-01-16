* @ValidationCode : MjotMjEwNzM0Njc4OTpDcDEyNTI6MTY4OTc0OTY1NjA5MTpJVFNTOi0xOi0xOjE4MTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1810
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.OFS.INTEREST.PAID(SEL.LIST.AZ)
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,M o M.VAR
* 14-07-2023    Narmadha V             R22 Manual Conversion    Call routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_LAPAP.OFS.INTEREST.PAID.COMMON ;*R22 Auto Conversion - END
   $USING EB.LocalReferences

*----------------
* Opening Tables
*----------------

    FN.AZ = "F.AZ.ACCOUNT"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.ST = "F.STMT.ACCT.CR"
    F.ST = ""
    CALL OPF(FN.ST,F.ST)

    FN.DT = "F.DATES"
    F.DT = ""
    CALL OPF(FN.DT,F.DT)

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.ACC)

*----------------------------------
* Building date start point format
*----------------------------------

    LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
*LAST.WORKING.DATE = 20191227

*----------------------------
* Searching all record in AZ
*----------------------------
    Y.AZ.ID = SEL.LIST.AZ
    CALL F.READ(FN.AZ,Y.AZ.ID,R.AZ,F.AZ,ERRZ)
*    CALL GET.LOC.REF("AZ.ACCOUNT","L.TYPE.INT.PAY",POS)
EB.LocalReferences.GetLocRef("AZ.ACCOUNT","L.TYPE.INT.PAY",POS);* R22 UTILITY AUTO CONVERSION
    PAYMENT.TYPE = R.AZ<AZ.LOCAL.REF,POS>
    CUSTOMER = R.AZ<AZ.CUSTOMER>
    CALL OCOMO("AZ.ID/CUSTOMER: " : Y.AZ.ID : "/" : CUSTOMER)
    ID = CUSTOMER
    APAP.LAPAP.lapapCustomerId(ID,RS) ;*R22 Maunal Conversion

    IF PAYMENT.TYPE EQ "Reinvested" THEN

* AZ.END = Y.AZ.ID:"-":LAST.WORKING.DATE
* AZ.INI = Y.AZ.ID:"-":TODAY
*        AZ.END = Y.AZ.ID:"-":20191226
*        AZ.INI = Y.AZ.ID:"-":20191227


* SEL.CMD.ST = "SELECT ":FN.ST:" WITH @ID GE ":AZ.END:" AND @ID LE ":AZ.INI

        SEL.CMD.ST = "SELECT ":FN.ST:" WITH @ID LIKE ":Y.AZ.ID:"... AND INT.POST.DATE GE ":LAST.WORKING.DATE: " AND INT.POST.DATE LT " :TODAY

        CALL EB.READLIST(SEL.CMD.ST,SEL.LIST.ST,'',NO.OF.RECS,SEL.ERR.ST)
        LOOP
            REMOVE ST FROM SEL.LIST.ST SETTING TEMP.POS
        WHILE ST DO
            CALL OCOMO("STMT.ACCT.CR.ID= " : ST)
            CALL F.READ(FN.ST,ST,R.ST,F.ST,ERR.ST)

            INT.POST.DATE.AZ = R.ST<IC.STMCR.INT.POST.DATE>
            TAX.FOR.CUSTOMER.AZ = R.ST<IC.STMCR.TAX.FOR.CUSTOMER>
            TOTAL.INTEREST.AZ = R.ST<IC.STMCR.TOTAL.INTEREST>
            GRAND.TOTAL.AZ = R.ST<IC.STMCR.GRAND.TOTAL>

            IF TAX.FOR.CUSTOMER.AC EQ '' THEN

                TAX.FOR.CUSTOMER.AC = 0

            END

            IF TAX.FOR.CUSTOMER.AZ EQ '' THEN

                TAX.FOR.CUSTOMER.AZ = 0

            END


            AZ.ARR = INT.POST.DATE.AZ:",":TAX.FOR.CUSTOMER.AZ:",":TOTAL.INTEREST.AZ:",":GRAND.TOTAL.AZ

            CALL F.READ(FN.AC,Y.AZ.ID,R.AC,F.AC,ERRC)
            REINV.ACC = R.AC<AC.INTEREST.LIQU.ACCT>
*            CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",PS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",PS);* R22 UTILITY AUTO CONVERSION
            BAL = R.AC<AC.LOCAL.REF,PS>

            CALL F.READ(FN.AC,REINV.ACC,R.AC,F.AC,ERRC)
            REINV.SFF = R.AC<AC.CAP.DATE.D2.INT,1>
*            CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",PSREINV)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",PSREINV);* R22 UTILITY AUTO CONVERSION
            BALREINV = R.AC<AC.LOCAL.REF,PSREINV>

            AC.END = REINV.ACC:"-":REINV.SFF
            AC.INI = REINV.ACC:"-":TODAY

            SEL.CMD.AC = "SELECT ":FN.ST:" WITH @ID GE ":AC.END:" AND @ID LE ":AC.INI

            CALL EB.READLIST(SEL.CMD.AC,SEL.LIST.AC,'',NO.OF.RECS,SEL.ERR.AC)

            LOOP
                REMOVE AC FROM SEL.LIST.AC SETTING TEMP.POS

            WHILE AC DO

                CALL F.READ(FN.ST,AC,R.STC,F.ST,ERR.STC)

                INT.POST.DATE.AC = R.STC<IC.STMCR.INT.POST.DATE>
                TAX.FOR.CUSTOMER.AC = R.STC<IC.STMCR.TAX.FOR.CUSTOMER>
                TOTAL.INTEREST.AC = R.STC<IC.STMCR.TOTAL.INTEREST>
                GRAND.TOTAL.AC = R.STC<IC.STMCR.GRAND.TOTAL>
                AC.ARR = INT.POST.DATE.AC:",":TAX.FOR.CUSTOMER.AC:",":TOTAL.INTEREST.AC:",":GRAND.TOTAL.AC

                BALANCE = BAL + BALREINV

                TOTAL = RS : "," : CUSTOMER : ",":Y.AZ.ID[1,10]:",":AC[12,8]:"," : TOTAL.INTEREST.AZ+TOTAL.INTEREST.AC : "," : PAYMENT.TYPE : ",":BALANCE:",":INT.POST.DATE.AC:",":'REINVERTIDO':",":TAX.FOR.CUSTOMER.AZ+TAX.FOR.CUSTOMER.AC:",":GRAND.TOTAL.AZ+GRAND.TOTAL.AC
                CALL OCOMO("TRAMA=" : TOTAL)
                TT<-1> = TOTAL

            REPEAT

        REPEAT

    END ELSE


*AZ.END = Y.AZ.ID:"-":LAST.WORKING.DATE
*AZ.INI = Y.AZ.ID:"-":TODAY

        CALL F.READ(FN.AC,Y.AZ.ID,R.AC,F.AC,ERRC)
        LIQU.ACC = R.AC<AC.INTEREST.LIQU.ACCT>
*        CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",PS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",PS);* R22 UTILITY AUTO CONVERSION
        BAL = R.AC<AC.LOCAL.REF,PS>

        CALL F.READ(FN.AZ,Y.AZ.ID,R.AZ,F.AZ,ERRZ)
*        CALL GET.LOC.REF("AZ.ACCOUNT","L.TYPE.INT.PAY",POS)
EB.LocalReferences.GetLocRef("AZ.ACCOUNT","L.TYPE.INT.PAY",POS);* R22 UTILITY AUTO CONVERSION
        PAYMENT.TYPE = R.AZ<AZ.LOCAL.REF,POS>
        CUSTOMER = R.AZ<AZ.CUSTOMER>
        CALL OCOMO("AZ.ID/CUSTOMER: " : Y.AZ.ID : "/" : CUSTOMER)
        ID = CUSTOMER
        APAP.LAPAP.lapapCustomerId(ID,RS) ;*R22 Manual Conversion

*SEL.CMD.ST = "SELECT ":FN.ST:" WITH @ID GE ":AZ.END:" AND @ID LE ":AZ.INI

        SEL.CMD.ST = "SELECT ":FN.ST:" WITH @ID LIKE ":Y.AZ.ID:"... AND INT.POST.DATE GE ":LAST.WORKING.DATE: " AND INT.POST.DATE LT " :TODAY


        CALL EB.READLIST(SEL.CMD.ST,SEL.LIST.ST,'',NO.OF.RECS,SEL.ERR.ST)

        LOOP
            REMOVE ST FROM SEL.LIST.ST SETTING TEMP.POS
        WHILE ST DO

            CALL F.READ(FN.ST,ST,R.ST,F.ST,ERR.ST)

            INT.POST.DATE.AZ = R.ST<IC.STMCR.INT.POST.DATE>
            TAX.FOR.CUSTOMER.AZ = R.ST<IC.STMCR.TAX.FOR.CUSTOMER>
            TOTAL.INTEREST.AZ = R.ST<IC.STMCR.TOTAL.INTEREST>
            GRAND.TOTAL.AZ = R.ST<IC.STMCR.GRAND.TOTAL>


            IF TAX.FOR.CUSTOMER.AC EQ '' THEN

                TAX.FOR.CUSTOMER.AC = 0

            END

            IF TAX.FOR.CUSTOMER.AZ EQ '' THEN

                TAX.FOR.CUSTOMER.AZ = 0

            END


            NO.REINV = RS:",":CUSTOMER:",":ST[1,10]:",":ST[12,8]:",":TOTAL.INTEREST.AZ:",":PAYMENT.TYPE:",":BAL:",":INT.POST.DATE.AZ:",":LIQU.ACC:",":TAX.FOR.CUSTOMER.AZ:",":GRAND.TOTAL.AZ
            CALL OCOMO("TRAMA=" : NO.REINV)
            TT<-1> = NO.REINV

        REPEAT


    END


    M.VAR = DCOUNT(TT,@FM)
    FOR A = 1 TO M.VAR STEP 1

* CRT TT<A>

        ARR = ""
        ARR<-1> = "MISERVICION-": Y.AZ.ID         ;*A
        ARR<-1> = "IDENTIFICACION,CLIENTE,CUENTA,DIA_PAGO_INTERESES,INTERESES_PAGADOS,FORMA_PAGO_INTERESES,BALANCE,FECHA_HORA_LOG,CUENTA_RECIBE_INT,IMPUESTO_GOBIERNO,INTERESES_MENOS_IMP";
        ARR<-1> = "C,C,C,C,C,C,C,C,C,C,C,"
        ARR<-1> = TT<A>
        ARR<-1> = "PAGOS_INT_DEPOSITOS_BACTH"
        CALL OCOMO ("ARR=" : ARR)
        APAP.LAPAP.lapapBuildMonitorLoad(ARR);* R22 Manual conversion

    NEXT A

END
