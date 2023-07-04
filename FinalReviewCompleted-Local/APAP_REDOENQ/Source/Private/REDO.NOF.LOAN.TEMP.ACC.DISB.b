$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.LOAN.TEMP.ACC.DISB(Y.FIN.ARRR)
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath G
*Program   Name    :REDO.NOF.LOAN.CRD.ACC.DISB
*----------------------------------------------------------------------------------

*DESCRIPTION       : This is no-file routine used to show the list of account nos for a field in version
*
*
*LINKED WITH       :VERSION>REDO.FT.TT.TRANSACTION,REDO.AA.LTCC
*---------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                    Reference                   Description
* 01-JUN-2017          Edwin Charles D       R15 Upgrade                  Initial Creation
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

OPENFILES:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    L.APPLS = 'AZ.PRODUCT.PARAMETER'
    L.FIELDS = 'L.AZ.RE.INV.CAT'
    CALL MULTI.GET.LOC.REF(L.APPLS,L.FIELDS,L.POS)
    Y.POS.RE.INV.CAT = L.POS<1,1>

RETURN

PROCESS:

    Y.ACC = R.NEW(FT.TN.DEBIT.ACCT.NO)
    IF Y.ACC[1,2] EQ 'AA' THEN
        CALL F.READ(FN.AA.ARRANGEMENT,Y.ACC,R.AA.ARR,F.AA.ARRANGEMENT,AA.AC.ERR)
        Y.ACC = R.AA.ARR<AA.ARR.LINKED.APPL.ID>
    END
    CALL F.READ(FN.ACCOUNT,Y.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUS = R.ACCOUNT<AC.CUSTOMER>

    SEL.CMD = 'SELECT ':FN.AZ.PRODUCT.PARAMETER:' WITH L.AZ.RE.INV.CAT NE ""'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR.APP,SEL.ERR)
    APP.CNT = 1
    LOOP
    WHILE APP.CNT LE NOR.APP
        APP.ID = SEL.LIST<APP.CNT>
        CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,APP.ID,R.APP,AP.ER)
        RE.INV.CATEG = R.APP<AZ.APP.LOCAL.REF,Y.POS.RE.INV.CAT>
        IF RE.INV.CATEG THEN
            VAR.RE.INV.CATEG<-1> = R.APP<AZ.APP.LOCAL.REF,Y.POS.RE.INV.CAT>
        END
        APP.CNT += 1
    REPEAT

    GOSUB SUB.PROCESS

RETURN

SUB.PROCESS:


    SEL.CMD.ACC = 'SELECT ':FN.ACCOUNT:' WITH CUSTOMER EQ ':Y.CUS:' AND ((CATEGORY GE 1000 AND CATEGORY LE 1999) OR (CATEGORY GE 6000 AND CATEGORY LE 6599))'
    CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NOF.RECS,SEL.AC.ERR)
    LOOP
        REMOVE Y.AC.ID FROM SEL.LIST.ACC SETTING POS.L
    WHILE Y.AC.ID:POS.L
        CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERRR)
        Y.CATEG = R.ACCOUNT<AC.CATEGORY>
        LOCATE Y.CATEG IN VAR.RE.INV.CATEG SETTING POS.LOC ELSE
            Y.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
            CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            Y.SHORT.TIT = R.CUSTOMER<EB.CUS.SHORT.NAME>
            Y.FIN.ARRR<-1> = Y.AC.ID:'*':Y.CUS.ID:'*':Y.SHORT.TIT
        END

    REPEAT

RETURN

PGM.END:

END
