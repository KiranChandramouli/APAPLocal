SUBROUTINE REDO.APAP.CUS.EXP.CLASSIFY

*-----------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CUS.EXP.CLASSIFY
*-----------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display header of REDO.EACH.TRANS.DETAILS.ENQ
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.CUS.EXPIRED.DOC.REPOR
*-----------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*--------
PROCESS:
*********
    Y.CLASSIFICATION = ''
    Y.EXP.DATE.FROM =''
    Y.EXP.DATE.TO = ''
    Y.CLIENT.ID = ''
    Y.ACC.EXECUTIVE =''
    Y.AGENCY = ''
    Y.CLIENT.TYPE = ''
    Y.USER = ''
    Y.DOC.TYPE = ''



    LOCATE "EXP.DATE.FROM" IN ENQ.SELECTION<2,1> SETTING Y.EXP.DATE.FROM.POS THEN
        Y.EXP.DATE.FROM = ENQ.SELECTION<4,Y.EXP.DATE.FROM.POS>
        Y.AC.TYPE.1 = ICONV(Y.EXP.DATE.FROM<1,1,1>,'DJ')
        Y.EXP.DATE.FROM = OCONV(Y.AC.TYPE.1,'D4E/')
    END

    LOCATE "EXP.DATE.TO" IN ENQ.SELECTION<2,1> SETTING Y.EXP.DATE.TO.POS THEN
        Y.EXP.DATE.TO = ENQ.SELECTION<4,Y.EXP.DATE.TO.POS>
        Y.AC.TYPE.2 = ICONV(Y.EXP.DATE.TO<1,1,1>,'DJ')
        Y.EXP.DATE.TO = OCONV(Y.AC.TYPE.2,'D4E/')
    END

    LOCATE "CLIENT.ID" IN ENQ.SELECTION<2,1> SETTING Y.CLIENT.ID.POS THEN
        Y.CLIENT.ID = ENQ.SELECTION<4,Y.CLIENT.ID.POS>
    END

    LOCATE "ACC.EXECUTIVE" IN ENQ.SELECTION<2,1> SETTING Y.ACC.EXECUTIVE.POS THEN
        Y.ACC.EXECUTIVE = ENQ.SELECTION<4,Y.ACC.EXECUTIVE.POS>
    END

    LOCATE "AGENCY" IN ENQ.SELECTION<2,1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = ENQ.SELECTION<4,Y.AGENCY.POS>
    END

    LOCATE "CLIENT.TYPE" IN ENQ.SELECTION<2,1> SETTING Y.CLIENT.TYPE.POS THEN
        Y.CLIENT.TYPE = ENQ.SELECTION<4,Y.CLIENT.TYPE.POS>
    END

    LOCATE "USER" IN ENQ.SELECTION<2,1> SETTING Y.USER.POS THEN
        Y.USER = ENQ.SELECTION<4,Y.USER.POS>
    END

    LOCATE "DOC.TYPE" IN ENQ.SELECTION<2,1> SETTING Y.DOC.TYPE.POS THEN
        Y.DOC.TYPE = ENQ.SELECTION<4,Y.DOC.TYPE.POS>
    END


    IF Y.EXP.DATE.FROM THEN
        Y.CLASSIFICATION = "Fecha vencimiento de: ":Y.EXP.DATE.FROM
    END ELSE
        Y.CLASSIFICATION = ""
    END


    IF Y.EXP.DATE.TO THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" Fecha vencimiento ha: ":Y.EXP.DATE.TO
        END ELSE
            Y.CLASSIFICATION = " Fecha vencimiento ha: ":Y.EXP.DATE.TO
        END
    END

    IF Y.CLIENT.ID THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"ID de cliente: ":Y.CLIENT.ID
        END ELSE
            Y.CLASSIFICATION ="ID de cliente: ":Y.CLIENT.ID
        END
    END
    IF Y.ACC.EXECUTIVE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"Ejecutivo de cuentas: ":Y.ACC.EXECUTIVE
        END ELSE
            Y.CLASSIFICATION ="Ejecutivo de cuentas: ":Y.ACC.EXECUTIVE
        END
    END



    IF Y.AGENCY THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" Sucursal: ":Y.AGENCY
        END ELSE
            Y.CLASSIFICATION = "Sucursal: ":Y.AGENCY
        END
    END
    IF Y.CLIENT.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" Tipo de cliente: ":Y.CLIENT.TYPE
        END ELSE
            Y.CLASSIFICATION = "Tipo de cliente: ":Y.CLIENT.TYPE
        END
    END


    IF Y.USER THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" Usuario: ":Y.USER
        END ELSE
            Y.CLASSIFICATION = "Usuario: ":Y.USER
        END
    END

    IF Y.DOC.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" Tipo de documento: ":Y.DOC.TYPE
        END ELSE
            Y.CLASSIFICATION = "Tipo de documento: ":Y.DOC.TYPE
        END
    END



    IF Y.EXP.DATE.FROM EQ '' AND Y.EXP.DATE.TO EQ '' AND Y.AGENCY EQ '' AND Y.CLIENT.ID EQ '' AND  Y.ACC.EXECUTIVE EQ '' AND Y.CLIENT.TYPE EQ '' AND Y.USER EQ '' AND Y.DOC.TYPE EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END

    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END

RETURN
END
