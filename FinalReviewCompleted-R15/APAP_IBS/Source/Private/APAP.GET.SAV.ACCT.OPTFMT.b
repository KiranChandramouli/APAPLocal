* @ValidationCode : MjoxOTg0ODQ1ODU2OkNwMTI1MjoxNjk4NDA1NTM4NTg5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS

*-----------------------------------------------------------------------------
* <Rating>108</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.SAV.ACCT.OPTFMT(MOB.REQUEST, MOB.RESPONSE)
*---------------------------------------------------------------------------------------------------
* Description :
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.CUSTOMER
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)


    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    CALL OPF(FN.DAO, F.DAO)

    FN.REDO.CARD.RENEWAL = 'F.REDO.CARD.RENEWAL'
    F.REDO.CARD.RENEWAL = ''
    CALL OPF(FN.REDO.CARD.RENEWAL, F.REDO.CARD.RENEWAL)

    POS.L.AC.ALPH.AC.NO =1
    CALL GET.LOC.REF("ACCOUNT","L.AC.ALPH.AC.NO",POS.L.AC.ALPH.AC.NO)

    LOCATE 'ACCOUNT.NUMBER' IN MOB.RESPONSE<1, 1, 1> SETTING ACC.POS ELSE NULL

    MOB.RESPONSE<1, 1, -1> = "L.AC.ALPH.AC.NO":@SM:"FUNDS.IN.TRANSIT":@SM:"PLEDGED.AMT":@SM:"ACCT.OFFICER":@SM:"BRANCH":@SM:"CARD.NUMBER.1":@SM:"CARD.EXPIRY.1":@SM:"CARD.NUMBER.2":@SM:"CARD.EXPIRY.2":@SM:"CARD.NUMBER.3":@SM:"CARD.EXPIRY.3"

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------

    APPL.IDS.CNT = DCOUNT(MOB.RESPONSE, @VM)

    FOR ID.CNT = 2 TO APPL.IDS.CNT

        ACCOUNT.ID = MOB.RESPONSE<1, ID.CNT, ACC.POS>
        R.ACCOUNT = ""
        READ  R.ACCOUNT FROM F.ACCOUNT , ACCOUNT.ID ELSE
            PRINT "ERROR READ ACCOUNT"
        END

        CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
        L.AC.ALPH.AC.NO =  R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.ALPH.AC.NO>

        O.DATA = ACCOUNT.ID
        CALL AI.REDO.GET.FUNDS.IN.TRANSIT
        Y.FUNDS.IN.TRANSIT = O.DATA

        O.DATA = ACCOUNT.ID
        CALL AI.REDO.GET.PLEDGED.AMT
        PLEDGED.AMT = O.DATA

        REDO.CARD.RENEWAL.ID =  CUSTOMER.ID:"-":ACCOUNT.ID
        R.REDO.CARD.RENEWAL = ""
        READ R.REDO.CARD.RENEWAL FROM F.REDO.CARD.RENEWAL , REDO.CARD.RENEWAL.ID ELSE
            PRINT "ERROR READ CARD.RENEWAL"
        END
		
		FOR CARD.CNT = 1 TO DCOUNT( R.REDO.CARD.RENEWAL<REDO.RENEW.PREV.CARD.NO>,@VM)
		    TEMP.CARD.EXPIRY = R.REDO.CARD.RENEWAL<REDO.RENEW.EXPIRY.DATE,CARD.CNT>
		    TEMP.CARD.NUMBER = R.REDO.CARD.RENEWAL<REDO.RENEW.PREV.CARD.NO,CARD.CNT>
		    TEMP.CARD.STATUS = R.REDO.CARD.RENEWAL<REDO.RENEW.STATUS,CARD.CNT>
		  
		    IF TEMP.CARD.STATUS EQ "97" AND TEMP.CARD.EXPIRY GE TODAY THEN
		        Y.CARD.NUMBER<-1>=TEMP.CARD.NUMBER[6,99]
		        Y.CARD.EXPIRY<-1>=TEMP.CARD.EXPIRY
		    END
        NEXT CARD.CNT

        R.CUSTOMER = ""
        READ   R.CUSTOMER FROM F.CUSTOMER , CUSTOMER.ID ELSE
            PRINT "ERROR READ CUSTOMER"
        END

        Y.ID.DAO = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER,1,1>
        R.DAO = ""
        READ R.DAO FROM F.DAO , Y.ID.DAO ELSE
            PRINT "ERROR READ DAO"
        END
        ACCT.OFFICER = R.DAO<EB.DAO.NAME,1,1>

        Y.ID.DAO = R.CUSTOMER<EB.CUS.OTHER.OFFICER,1,1>
        R.DAO = ""
        READ R.DAO FROM F.DAO , Y.ID.DAO ELSE
            PRINT "ERROR READ DAO"
        END
        BRANCHE = R.DAO<EB.DAO.NAME,1,1>


        MOB.RESPONSE<1, ID.CNT, -1> = L.AC.ALPH.AC.NO:@SM:Y.FUNDS.IN.TRANSIT:@SM:PLEDGED.AMT:@SM:ACCT.OFFICER:@SM:BRANCHE:@SM:Y.CARD.NUMBER<1>:@SM:Y.CARD.EXPIRY<1>:@SM:Y.CARD.NUMBER<2>:@SM:Y.CARD.EXPIRY<2>:@SM:Y.CARD.NUMBER<3>:@SM:Y.CARD.EXPIRY<3>
    NEXT ID.CNT

RETURN


END
