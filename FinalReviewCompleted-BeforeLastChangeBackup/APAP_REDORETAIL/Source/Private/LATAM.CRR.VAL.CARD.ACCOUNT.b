* @ValidationCode : MjoxNDA1NzM5NzU2OkNwMTI1MjoxNjgxMjc2NTUzMjYyOklUU1M6LTE6LTE6MTY5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 169
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
*-----------------------------------------------------------------------------
* <Rating>10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LATAM.CRR.VAL.CARD.ACCOUNT
*-----------------------------------------------------------------------------
* Company   Name    : APAP
* Developed By      : GASSALI - Temenos Application Management
* Program Name      : CRR.VAL.CARD.ACCOUNT
*------------------------------------------------------------------------------
* Description       : This is an validation routine which validates the account
*                     numbers attached to LATAM.CARD.ORDER application belongs to
*                     same customer otherwise it throws the error message
* Linked With       : LATAM.CARD.ORDER
*-----------------------------------------------------------------------------
* Revision History :
*-------------------
*  Date            Who             References           Description
* 28-07-2010                    ODR-2010-06-0322      Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            VM TO @VM, RESET TO RESET.1 (RESET IS RESEVERD KEY WORD)
*-----------------------------------------------------------
* Include Files
*-----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.ORDER

    TEMP.AF = AF
    TEMP.AV = AV

    GOSUB INITIALISE

    GOSUB PROCESS
    GOSUB RESET.1 ;* MANUAL R22 CODE CONVERSION
RETURN

*-----------
INITIALISE:
*-----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    ACCOUNTS = R.NEW(CARD.IS.ACCOUNT)
RETURN

*--------
PROCESS:
*--------

    NO.OF.ACC = DCOUNT(ACCOUNTS,@VM) ;* MANUAL R22 CODE CONVERSION
    FOR ACCOUNT.NO = 1 TO NO.OF.ACC
        ACCOUNT.ID = ACCOUNTS<1,ACCOUNT.NO>

        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
        Y.RELATION = R.ACCOUNT<AC.RELATION.CODE>
        IF R.NEW(CARD.IS.CUSTOMER.NO)<1,1> NE R.ACCOUNT<AC.CUSTOMER> THEN
            IF Y.JOINT.HOLDER EQ R.NEW(CARD.IS.CUSTOMER.NO)<1> AND Y.RELATION EQ '203' THEN
                GOSUB END.PROGRAM
            END ELSE
                IF ACCOUNT.NO EQ NO.OF.ACC THEN
                    AF = CARD.IS.ACCOUNT
                    AV = ACCOUNT.NO
                    ETEXT = 'EB-INVALID.CUST'
                    CALL STORE.END.ERROR
                END
            END
        END
        ELSE
            GOSUB END.PROGRAM
        END

    NEXT ACCOUNT.NO
RETURN

*------
RESET.1: ;*MANUAL R22 CODE CONVERSION
*------
    AF = TEMP.AF
    AV = TEMP.AV
RETURN
END.PROGRAM:
*---------------
END
*-----------------------------------------------------------------------------------------------------
