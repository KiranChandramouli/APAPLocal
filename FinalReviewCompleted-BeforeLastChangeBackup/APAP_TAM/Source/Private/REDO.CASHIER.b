* @ValidationCode : MjoxMjg5MjcyMDQwOkNwMTI1MjoxNjg0ODQxODgxMTc0OklUU1M6LTE6LTE6NTk5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 599
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
PROGRAM REDO.CASHIER

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.STMT.ENTRY

    FN.ACCOUNT     = 'F.ACCOUNT'
    F.ACCOUNT      = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*  DEBUG
    FN.ACCT.ENT.TODAY='F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY=''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.STMT.ENTRY  = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    SEL.ACC = 'SELECT ':FN.ACCT.ENT.TODAY
    CALL EB.READLIST(SEL.ACC,ACC.ID.LST,'',NO.OF.ACC,ACC.ERR)

    LOOP
        REMOVE ACC.ID FROM ACC.ID.LST SETTING ACC.ID.POS
    WHILE ACC.ID:ACC.ID.POS
        CALL F.READ(FN.ACCT.ENT.TODAY,ACC.ID,R.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY,ACCT.ENT.ERR)
        LOOP
            REMOVE Y.STMT.ENTRY FROM R.ACCT.ENT.TODAY SETTING Y.STMT.POS
        WHILE Y.STMT.ENTRY:Y.STMT.POS
            CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ERR)
            IF R.STMT.ENTRY EQ '' THEN
                CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.ENTRY,R.STMT.ENTRY,F.STMT.ENTRY.DETAIL,Y.ERR)
            END
            STMT.TXN.CODE=R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
            STMT.VAL.DATE=R.STMT.ENTRY<AC.STE.VALUE.DATE>
        REPEAT
    REPEAT
RETURN


END
