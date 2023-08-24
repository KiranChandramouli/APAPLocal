* @ValidationCode : Mjo5NTYzMTI3OTY6Q3AxMjUyOjE2ODI0MTIzNTc5MTM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.CONTRACT.NUMB

*----------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : VIGNESH KUMAAR M R
* Program Name  : REDO.V.VAL.CONTRACT.NUMB
*----------------------------------------------------------------------------------------------------------------------
* This routine is used to validate the arrangement number and update the customer and currency information
*----------------------------------------------------------------------------------------------------------------------
* Linked with   : TELLER,REDO.OVERPYMT.CASH
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*----------------------------------------------------------------------------------------------------------------------
* DATE          NAME               Refernce         DESCRIPTION
* 11-12-2014    Vignesh Kumaar R   AA OVERPAYMENT   INITIAL CREATION
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LOC.APPLICATION   = "TELLER":@FM:"ACCOUNT"
    LOC.FIELDS        = 'L.COMMENTS':@VM:'L.TT.CLIENT.NME':@FM:'L.OD.STATUS'
    LOC.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    POS.L.COMMENTS      = LOC.POS<1,1>
    POS.L.TT.CLIENT.NME = LOC.POS<1,2>
    POS.L.OD.STATUS     = LOC.POS<2,1>

    IF NUM(COMI) THEN
        CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        Y.ARRANGEMENT.NUMBER = R.ACCOUNT<AC.ARRANGEMENT.ID>
        IF Y.ARRANGEMENT.NUMBER EQ '' THEN
            ETEXT = "EB-NOT.AA.AC"
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
            R.NEW(TT.TE.CURRENCY.1) = R.ACCOUNT<AC.CURRENCY>
            GOSUB GET.CUST.ENRI
        END
    END ELSE
        CALL F.READ(FN.AA.ARRANGEMENT,COMI,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
        IF AA.ARRANGEMENT.ERR THEN
            ETEXT = "EB-NOT.AA.AC"
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            COMI = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
            Y.CUSTOMER = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
            R.NEW(TT.TE.CURRENCY.1) = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
            GOSUB GET.CUST.ENRI
        END
    END
    IF ETEXT ELSE
        GOSUB CHECK.FOR.DUE.BILLS
    END
RETURN

*-----------------------------------------------------------------------------------------------------------------------
GET.CUST.ENRI:
*-----------------------------------------------------------------------------------------------------------------------

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CUSTOMER.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>


    R.NEW(TT.TE.LOCAL.REF) <1,POS.L.COMMENTS> = Y.CUSTOMER
    R.NEW(TT.TE.LOCAL.REF) <1,POS.L.TT.CLIENT.NME> = Y.CUSTOMER.NAME

RETURN
*-----------------------------------------------------------------------------------------------------------
CHECK.FOR.DUE.BILLS:
*-----------------------------------------------------------------------------------------------------------
* Here we are going to check whether loan has any Due Bills outstanding.

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    Y.AA.ID = ''
    CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.DET)
    Y.SET.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @SM TO @FM IN Y.SET.STATUS
    CHANGE @VM TO @FM IN Y.SET.STATUS
    LOCATE 'UNPAID' IN Y.SET.STATUS<1> SETTING POS.DUE THEN
        ETEXT = 'EB-DUES.ARE.THERE'
        CALL STORE.END.ERROR
    END
    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> NE 'CUR' THEN
        ETEXT = 'EB-REDO.LOAN.STATUS'
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------
END
