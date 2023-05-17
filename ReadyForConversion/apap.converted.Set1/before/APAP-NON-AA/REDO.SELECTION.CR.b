*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.SELECTION.CR
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SELECTION.CR
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.AZ.DYNAMIC.DEPOSITS
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    26 09 2010       Jeyachandran S          ODR-2010-03-0166          Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB INITIALIZE
    GOSUB PROCESS.PARA

    RETURN
*--------------------------------------------------------------------------------------------------------
****************
INITIALIZE:
***************
    Y.CRITERIA = ''
    Y.AGENCY = ''
    Y.REGION = ''
    Y.CLIENT.TYPE = ''
    Y.ACC.EXE = ''
    Y.INV.TYPE = ''
    Y.CLIENT.CODE = ''
    Y.INV.NUM = ''
    Y.PREV.NUM = ''
    Y.CURR.ID = ''
    Y.AC.TYPE = ''
    Y.OPEN.DATE = ''
    Y.CANCELL.DATE = ''
    RETURN
*************
PROCESS.PARA:
*************

    LOCATE "AGENCY" IN D.FIELDS<1> SETTING AGENCY.POS THEN
        Y.AGENCY =D.RANGE.AND.VALUE<AGENCY.POS>
    END

    IF Y.AGENCY THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA = 'Agencia - ':Y.AGENCY
        END ELSE
            Y.CRITERIA = ',':'Agencia - ':Y.AGENCY
        END
    END

    LOCATE "REGION" IN D.FIELDS<1> SETTING REGION.POS THEN
        Y.REGION =D.RANGE.AND.VALUE<REGION.POS>
    END

    IF Y.REGION THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Region - ':Y.REGION
        END ELSE
            Y.CRITERIA := ',':'Region - ':Y.REGION
        END
    END

    LOCATE "CLIENT.TYPE" IN D.FIELDS<1> SETTING CLIENT.TYPE.POS THEN
        Y.CLIENT.TYPE =D.RANGE.AND.VALUE<CLIENT.TYPE.POS>
        CONVERT SM TO ' ' IN Y.CLIENT.TYPE
    END

    IF Y.CLIENT.TYPE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Tipo de Clinte - ':Y.CLIENT.TYPE
        END ELSE
            Y.CRITERIA := ',':'Tipo de Clinte - ':Y.CLIENT.TYPE
        END
    END

    LOCATE "ACCOUNT.EXECUTIVE" IN D.FIELDS<1> SETTING ACC.EXE.POS THEN
        Y.ACC.EXE =D.RANGE.AND.VALUE<ACC.EXE.POS>
    END

    IF Y.ACC.EXE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Oficial de cuenta - ':Y.ACC.EXE
        END ELSE
            Y.CRITERIA := ',':'Oficial de cuenta - ':Y.ACC.EXE
        END
    END

    LOCATE "INVESTMENT.TYPE" IN D.FIELDS<1> SETTING INV1.POS THEN
        Y.INV.TYPE =D.RANGE.AND.VALUE<INV1.POS>
    END

    IF Y.INV.TYPE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Tipo de Inversion - ':Y.INV.TYPE
        END ELSE
            Y.CRITERIA := ',':'Tipo de Inversion - ':Y.INV.TYPE
        END
    END

    LOCATE "CLIENT.CODE" IN D.FIELDS<1> SETTING CLIENT.POS THEN
        Y.CLIENT.CODE =D.RANGE.AND.VALUE<CLIENT.POS>
    END

    IF Y.CLIENT.CODE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Codigo(s) Cliente(s)- ':Y.CLIENT.CODE
        END ELSE
            Y.CRITERIA := ',':'Codigo(s) Cliente(s)- ':Y.CLIENT.CODE
        END
    END

    LOCATE "INVESTMENT.NUMBER" IN D.FIELDS<1> SETTING INV.POS THEN
        Y.INV.NUM =D.RANGE.AND.VALUE<INV.POS>
    END

    IF Y.INV.NUM THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Numero Inversion - ':Y.INV.NUM
        END ELSE
            Y.CRITERIA := ',':'Numero Inversion - ':Y.INV.NUM
        END
    END

    LOCATE "PREV.INV.NUMBER" IN D.FIELDS<1> SETTING PREV.NUM.POS THEN
        Y.PREV.NUM =D.RANGE.AND.VALUE<PREV.NUM.POS>
    END

    IF Y.PREV.NUM THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'No. Inversion Ant.- ':Y.PREV.NUM
        END ELSE
            Y.CRITERIA := ',':'No. Inversion Ant.- ':Y.PREV.NUM
        END
    END

    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING CURR.POS THEN
        Y.CURR.ID =D.RANGE.AND.VALUE<CURR.POS>
    END

    IF Y.CURR.ID THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Moneda Inversion - ':Y.CURR.ID
        END ELSE
            Y.CRITERIA := ',':'Moneda Inversion - ':Y.CURR.ID
        END
    END


    LOCATE "ACCOUNT.TYPE" IN D.FIELDS<1> SETTING AC.TYPE.POS THEN
        Y.AC.TYPE =D.RANGE.AND.VALUE<AC.TYPE.POS>
    END

    IF Y.AC.TYPE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Tipo de Cuenta - ':Y.AC.TYPE
        END ELSE
            Y.CRITERIA := ',':'Tipo de Cuenta - ':Y.AC.TYPE
        END
    END

    LOCATE "OPENING.DATE" IN D.FIELDS<1> SETTING OPEN.DATE.POS THEN
        Y.OPEN.DATE =D.RANGE.AND.VALUE<OPEN.DATE.POS>
    END

    IF Y.OPEN.DATE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Fecha Apertura Inv. - ':Y.OPEN.DATE
        END ELSE
            Y.CRITERIA := ',':'Fecha Apertura Inv. - ':Y.OPEN.DATE
        END
    END

    LOCATE "CANCELL.DATE" IN D.FIELDS<1> SETTING CANCELL.DATE.POS THEN
        Y.CANCELL.DATE =D.RANGE.AND.VALUE<CANCELL.DATE.POS>
    END

    IF Y.CANCELL.DATE THEN
        IF Y.CRITERIA EQ '' THEN
            Y.CRITERIA := 'Fecha Cancelac. Inv.- ':Y.CANCELL.DATE
        END ELSE
            Y.CRITERIA := ',':'Fecha Cancelac. Inv.- ':Y.CANCELL.DATE
        END
    END
    O.DATA = Y.CRITERIA

    RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
