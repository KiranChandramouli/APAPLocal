* @ValidationCode : MjoxODgzODY5ODg0OkNwMTI1MjoxNjgxMjgzOTQyNzAxOklUU1M6LTE6LTE6NzI5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 729
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.TT.AUT.FD.PREC
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.TT.AUT.FD.PREC
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a AUTHORIZATION ROUTINE attached to the version TELLER,AZ.FD.PREC
*                    It is to discount the penalty amount from Net amount of the Deposit which is preclosed
*In Parameter      :
*Out Parameter     :
*Files  Used       : TELLER            As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  20/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.USER
    $INSERT I_F.TELLER
*TUS Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*TUS End
    GOSUB INIT
    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

RETURN

*---------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************
    DEPOSIT.ID = R.NEW(TT.TE.ACCOUNT.1)

    CALL F.READ(FN.AZ.ACCOUNT,DEPOSIT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
    IF R.AZ.ACCOUNT THEN
        Y.CATEGORY = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
        Y.CUS = R.AZ.ACCOUNT<AZ.CUSTOMER>
        Y.CURRENCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    END

    GOSUB GET.LOCAL.FLD.POS

    GOSUB GET.TXN.CODE

    IF R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.PER> GT '0.00' THEN
        PENALTY.AMOUNT = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT>
        INT.LIQ.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
        CALL F.READ(FN.ACCOUNT,INT.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR1)
*TUS Start
        CALL EB.READ.HVT('EB.CONTRACT.BALANCES', INT.LIQ.ACCT, R.ECB, ECB.ERR)
*    IF R.ACCOUNT AND Y.AC.ERR1 EQ '' THEN
        IF R.ECB AND Y.AC.ERR1 EQ '' THEN
*      INT.LIQ.ONL.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
            INT.LIQ.ONL.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>
*TUS End
            DEPOSIT.AC = ID.NEW
            CALL F.READ(FN.ACCOUNT,DEPOSIT.AC,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR2)
            IF R.ACCOUNT AND Y.AC.ERR2 EQ '' AND PENALTY.AMOUNT GT '0'THEN
                GOSUB PEN.AMT.ACCOUNTING
            END
        END
        RETURN
*----------------------------------------------------------------------------------------------------------
GET.TXN.CODE:
*************
        CALL F.READ(FN.AZ.PRODUCT.PARAMETER,Y.CATEGORY,R.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER,Y.AZ.ERR)
        IF R.AZ.PRODUCT.PARAMETER AND Y.AZ.ERR EQ '' THEN
            Y.DR.CODE =  R.AZ.PRODUCT.PARAMETER<AZ.APP.DR.TXN.CODE>
            Y.CR.CODE = R.AZ.PRODUCT.PARAMETER<AZ.APP.CR.TXN.CODE>
        END
        RETURN
*----------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************
        APPL.ARRAY = 'TELLER':@FM:'ACCOUNT'
        FLD.ARRAY  = 'L.TT.PENAL.PER':@VM:'L.TT.PENAL.AMT':@FM:'L.AC.REINVESTED'
        FLD.POS    = ''
        CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
        LOC.L.TT.PENAL.PER = FLD.POS<1,1>
        LOC.L.TT.PENAL.AMT = FLD.POS<1,2>
        LOC.L.AC.REINVESTED = FLD.POS<2,1>

        RETURN
*----------------------------------------------------------------------------------------------------------
PEN.AMT.ACCOUNTING:
*******************
* To raise accounting entries

        YENTRY.REC = ''

        Y.ACCT.OFF = R.ACCOUNT<AC.ACCOUNT.OFFICER>

        IF R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.REINVESTED> EQ 'YES' THEN
            IF INT.LIQ.ONL.BAL GT '0' THEN
                IF INT.LIQ.ONL.BAL GT PENALTY.AMOUNT THEN
                    Y.AMOUNT = -1 * PENALTY.AMOUNT
                    Y.DR.ACCT = INT.LIQ.ACCT

                    GOSUB BUILD.DR1.ENTRY

                    Y.AMOUNT = PENALTY.AMOUNT
                    GOSUB BUILD.CR.ENTRY
                END

                IF INT.LIQ.ONL.BAL LT PENALTY.AMOUNT THEN
                    Y.AMOUNT = -1 * INT.LIQ.ONL.BAL
                    Y.DR.ACCT = INT.LIQ.ACCT

                    GOSUB BUILD.DR1.ENTRY

                    Y.AMOUNT = PENALTY.AMOUNT - INT.LIQ.ONL.BAL
                    Y.AMOUNT = -1 * Y.AMOUNT
                    Y.DR.ACCT = ID.NEW

                    GOSUB BUILD.DR2.ENTRY

                    Y.AMOUNT = PENALTY.AMOUNT
                    GOSUB BUILD.CR.ENTRY
                END
            END ELSE
                GOSUB DR.DEP.ENTRIES
            END
        END
        IF R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.REINVESTED> EQ 'NO' THEN
            GOSUB DR.DEP.ENTRIES
        END

        Y.TYPE='SAO'

        Y.PREV.STMT.NO = R.NEW(TT.TE.STMT.NO)

        CALL EB.ACCOUNTING.WRAPPER('TT',Y.TYPE,YENTRY.REC,'',EB.ACCT.ERR.MSG)

        Y.ST.NO.POS = DCOUNT(R.NEW(TT.TE.STMT.NO),@VM) + 1

        R.NEW(TT.TE.STMT.NO)<1,Y.ST.NO.POS> = Y.PREV.STMT.NO

        RETURN
*---------------------------------------------------------------------------------------------------------
DR.DEP.ENTRIES:
***************
        Y.AMOUNT = -1 * PENALTY.AMOUNT
        Y.DR.ACCT = ID.NEW

        GOSUB BUILD.DR2.ENTRY
        Y.AMOUNT = PENALTY.AMOUNT
        GOSUB BUILD.CR.ENTRY
        RETURN
*----------------------------------------------------------------------------------------------------------
BUILD.DR1.ENTRY:
***************
* For stmt entry

        ENTRY1.REC=""
        ENTRY1.REC<AC.STE.ACCOUNT.NUMBER> =  Y.DR.ACCT
        ENTRY1.REC<AC.STE.AMOUNT.LCY> = Y.AMOUNT
        ENTRY1.REC<AC.STE.TRANSACTION.CODE> = Y.DR.CODE
        ENTRY1.REC<AC.STE.THEIR.REFERENCE> = ID.NEW
        ENTRY1.REC<AC.STE.CUSTOMER.ID> = Y.CUS
        ENTRY1.REC<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFF
        ENTRY1.REC<AC.STE.PRODUCT.CATEGORY> = Y.CATEGORY
        ENTRY1.REC<AC.STE.VALUE.DATE> = TODAY
        ENTRY1.REC<AC.STE.CURRENCY> = Y.CURRENCY
        ENTRY1.REC<AC.STE.OUR.REFERENCE> = ID.NEW
        ENTRY1.REC<AC.STE.EXPOSURE.DATE> = TODAY
        ENTRY1.REC<AC.STE.TRANS.REFERENCE> = ID.NEW
        ENTRY1.REC<AC.STE.SYSTEM.ID> = 'TT'
        ENTRY1.REC<AC.STE.BOOKING.DATE> = TODAY
        ENTRY1.REC<AC.STE.COMPANY.CODE> = ID.COMPANY
        ENTRY1.REC<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        ENTRY1.REC<AC.STE.CURRENCY.MARKET> = "1"

        YENTRY.REC<-1> = LOWER(ENTRY1.REC)

        RETURN
*------------------------------------------------------------------------------------------------------
BUILD.DR2.ENTRY:
***************
* For stmt entry

        ENTRY2.REC=""
        ENTRY2.REC<AC.STE.ACCOUNT.NUMBER> = Y.DR.ACCT
        ENTRY2.REC<AC.STE.AMOUNT.LCY> = Y.AMOUNT
        ENTRY2.REC<AC.STE.TRANSACTION.CODE> = Y.DR.CODE
        ENTRY2.REC<AC.STE.THEIR.REFERENCE> = ID.NEW
        ENTRY2.REC<AC.STE.CUSTOMER.ID> = Y.CUS
        ENTRY2.REC<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFF
        ENTRY2.REC<AC.STE.PRODUCT.CATEGORY> = Y.CATEGORY
        ENTRY2.REC<AC.STE.VALUE.DATE> = TODAY
        ENTRY2.REC<AC.STE.CURRENCY> = Y.CURRENCY
        ENTRY2.REC<AC.STE.OUR.REFERENCE> = ID.NEW
        ENTRY2.REC<AC.STE.EXPOSURE.DATE> = TODAY
        ENTRY2.REC<AC.STE.TRANS.REFERENCE> = ID.NEW
        ENTRY2.REC<AC.STE.SYSTEM.ID> = 'TT'
        ENTRY2.REC<AC.STE.BOOKING.DATE> = TODAY
        ENTRY2.REC<AC.STE.COMPANY.CODE> = ID.COMPANY
        ENTRY2.REC<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        ENTRY2.REC<AC.STE.CURRENCY.MARKET> = "1"

        YENTRY.REC<-1> = LOWER(ENTRY2.REC)

        RETURN

*---------------------------------------------------------------------------------------------------------
BUILD.CR.ENTRY:
***************
* For categ entry

        AENTRY.REC=""
        AENTRY.REC<AC.CAT.AMOUNT.LCY> = Y.AMOUNT
        AENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.CR.CODE
        AENTRY.REC<AC.CAT.PL.CATEGORY> = '50000'
        AENTRY.REC<AC.CAT.CUSTOMER.ID> = Y.CUS
        AENTRY.REC<AC.CAT.ACCOUNT.OFFICER> = Y.ACCT.OFF
        AENTRY.REC<AC.CAT.PRODUCT.CATEGORY> = Y.CURRENCY
        AENTRY.REC<AC.CAT.VALUE.DATE> = TODAY
        AENTRY.REC<AC.CAT.CURRENCY> = Y.CURRENCY
        AENTRY.REC<AC.CAT.OUR.REFERENCE> = ID.NEW
        AENTRY.REC<AC.CAT.EXPOSURE.DATE> = TODAY
        AENTRY.REC<AC.CAT.TRANS.REFERENCE> = ID.NEW
        AENTRY.REC<AC.CAT.SYSTEM.ID>= 'TT'
        AENTRY.REC<AC.CAT.BOOKING.DATE> = TODAY
        AENTRY.REC<AC.CAT.COMPANY.CODE> = ID.COMPANY
        AENTRY.REC<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        AENTRY.REC<AC.CAT.CURRENCY.MARKET> = "1"

        YENTRY.REC<-1> = LOWER(AENTRY.REC)
        RETURN
    END
