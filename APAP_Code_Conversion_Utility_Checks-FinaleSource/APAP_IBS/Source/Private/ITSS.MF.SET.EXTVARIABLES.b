* @ValidationCode : MjoxMjg2NDI0OTk1OkNwMTI1MjoxNzAyOTg4MzIwMzE2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:48:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.MF.SET.EXTVARIABLES(USER.ID)


*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                   FM TO @FM
*19-12-2023               Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON


*EB.EXTERNAL$USER.ID,
*EB.EXTERNAL$CUSTOMER,
*EB.EXTERNAL$ACCOUNTS,
*EB.EXTERNAL$ACCOUNT.TITLES,
*EB.EXTERNAL$CHANNEL,
*EB.EXTERNAL$CHANNEL.TYPE,
*EXT.EXTERNAL.USER
*EXT.ARRANGEMENT
*EXT.CUSTOMER
*EXT.SMS.EXTERNAL.CUSTOMER
*EXT.CUSTOMER.ACCOUNTS
*EXT.CUSTOMER.ACCOUNTS.TITLES
*EXT.SMS.CUSTOMERS
*EXT.SMS.CUSTOMER.ARRANGEMENTS
    MOB.USER.VARIABLES<1,1> = 'EXT.EXTERNAL.USER'
    MOB.USER.VARIABLES<2,1> = 'EXT.ARRANGEMENT'
    MOB.USER.VARIABLES<3,1> = 'EXT.CUSTOMER'
    MOB.USER.VARIABLES<4,1> = 'EXT.SMS.EXTERNAL.CUSTOMER'
    MOB.USER.VARIABLES<5,1> = 'EXT.CUSTOMER.ACCOUNTS'
    MOB.USER.VARIABLES<6,1> = 'EXT.CUSTOMER.ACCOUNTS.TITLES'
    MOB.USER.VARIABLES<7,1> = 'EXT.SMS.CUSTOMERS'
    MOB.USER.VARIABLES<8,1> = 'EXT.SMS.CUSTOMER.ARRANGEMENTS'
    MOB.USER.VARIABLES<9,1> = 'EXT.SMS.TODAY'

    GOSUB INITIALISE

    GOSUB PROCESS

    GOSUB SET.SESSION.VARS

RETURN

INITIALISE:

    EB.EXTERNAL$USER.ID = USER.ID
    MOB.USER.VARIABLES<1,2> = USER.ID
    EB.EXTERNAL$CUSTOMER = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
    MOB.USER.VARIABLES<2,2> =  R.EB.EXTERNAL.USER<EB.XU.ARRANGEMENT>
    MOB.USER.VARIABLES<3,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<4,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<7,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<8,2> = 'EXT.SMS.CUSTOMER.ARRANGEMENTS'
    MOB.USER.VARIABLES<9,2> = TODAY


    FN.CUST.ACCT = 'F.CUSTOMER.ACCOUNT'
    F.CUST.ACCT = ''
    CALL OPF(FN.CUST.ACCT, F.CUST.ACCT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)


RETURN

PROCESS:

    E.CUS.ACC = ''
    CALL F.READ(FN.CUST.ACCT, EB.EXTERNAL$CUSTOMER, R.CUST.ACCT, F.CUST.ACCT, E.CUS.ACC)

    IF NOT(E.CUS.ACC) THEN
        EB.EXTERNAL$ACCOUNTS = LOWER(LOWER(LOWER(R.CUST.ACCT)))
        MOB.USER.VARIABLES<5,2> =  EB.EXTERNAL$ACCOUNTS
        ACC.CNT = DCOUNT(R.CUST.ACCT, @FM)
        FOR I=1 TO ACC.CNT
            ACCT.ID = R.CUST.ACCT<I>
            E.ACC = ''
*  CALL F.READ(FN.ACCOUNT, ACCT.ID, R.ACCOUNT, F.ACCOUNT, E.ACC)
            READ R.ACCOUNT FROM F.ACCOUNT, ACCT.ID ELSE E.ACC = 'RECORD NOT FOUND'
            IF NOT(E.ACC) THEN
                ACCT.TITLES<-1> = ACCT.ID:' ':R.ACCOUNT<AC.SHORT.TITLE>
            END
        NEXT I
        EB.EXTERNAL$ACCOUNT.TITLES = LOWER(LOWER(LOWER(ACCT.TITLES)))
        MOB.USER.VARIABLES<6,2> = EB.EXTERNAL$ACCOUNT.TITLES
    END

RETURN

SET.SESSION.VARS:

    USRVARSCNT = DCOUNT(MOB.USER.VARIABLES, @FM)

    FOR I=1 TO USRVARSCNT
*R22 Manual Code Conversion_Utility Check-Start
*       CALL System.setVariable(MOB.USER.VARIABLES<I, 1>, MOB.USER.VARIABLES<I, 2>)
        Y.MOB.USER.VARIABLES1 = MOB.USER.VARIABLES<I, 1>
        Y.MOB.USER.VARIABLES2 = MOB.USER.VARIABLES<I, 2>
        CALL System.setVariable(Y.MOB.USER.VARIABLES1, Y.MOB.USER.VARIABLES2)
*R22 Manual Code Conversion_Utility Check-End
    NEXT I

    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)

RETURN
END
