*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.DS.GET.CUENTA(VAR.ACCOUNT.NO)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.CUENTA
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the account value
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
        CALL REDO.DS.GET.PAY.FORM(VAR.PAY.FORM)
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


