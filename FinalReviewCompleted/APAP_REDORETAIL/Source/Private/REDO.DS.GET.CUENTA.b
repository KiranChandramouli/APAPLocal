* @ValidationCode : MjoxNDk2NTk4MzkxOkNwMTI1MjoxNjgyNTk4MDIxNTc0OnNhbWFyOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.GET.CUENTA(VAR.ACCOUNT.NO)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.CUENTA
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the account value
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB PROCESS

RETURN
*********
PROCESS:
**********
    BEGIN CASE

        CASE APPLICATION EQ 'ACCOUNT.CLOSURE'

            Y.ACCOUNT.NO  = R.NEW(AC.ACL.SETTLEMENT.ACCT)

            IF PGM.VERSION EQ ',REDO.EN.LINEA' THEN
                VAR.ACCOUNT.NO = Y.ACCOUNT.NO

            END ELSE
                VAR.ACCOUNT.NO = ''
            END

        CASE APPLICATION EQ 'AZ.ACCOUNT'

            Y.ACCOUNT.NO = R.NEW(AZ.NOMINATED.ACCOUNT)

            VAR.PAY.FORM = ''
*APAP.REDORETAIL.REDO.DS.GET.PAY.FORM(VAR.PAY.FORM)
            APAP.REDORETAIL.redoDsGetPayForm(varPayForm);* MANUAL R22 CODE CONVERSION
* WHILE DEBUG CHECK PAY.FORM VALUE IS AVAILABLE IN R.NEW

            IF ((PGM.VERSION EQ ',NOR.PRECLOSURE') OR (PGM.VERSION EQ ',NOR.PRECLOSURE.AUTH')) AND (VAR.PAY.FORM NE 'EFFECTIVO' AND ISDIGIT(Y.ACCOUNT.NO[1,3])) THEN       ;*PACS00930966
                VAR.ACCOUNT.NO = Y.ACCOUNT.NO
            END ELSE
                VAR.ACCOUNT.NO = ''
            END

    END CASE

RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
