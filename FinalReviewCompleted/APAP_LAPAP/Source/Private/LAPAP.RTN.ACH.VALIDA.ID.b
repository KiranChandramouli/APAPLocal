* @ValidationCode : MjotMTY2MTE2NDE5NTpDcDEyNTI6MTY4NDIyMjgxNDg2ODpJVFNTOi0xOi0xOjg1NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 856
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.RTN.ACH.VALIDA.ID

*---------------------------------------------------------------------
* Autor: Melvy, Modificación: Oliver - 12/09/2019 - GDC-612 - GDC-314
* Rutina utilizada para validar las Cedula/RNC/Pasaporte de las transferencias ACH entrantes
* Los archivos se depositan en la ruta: ../interface/ACH/Inward/CONVERT/
* Se corre el servicio BNK/LAPAP.CORRIGE.CUENTA.ACH y luego el PHANTON REDO.ACH.INWARD
*--------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON     ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER     ;*R22 AUTO CODE CONVERSION.END

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN


OPEN.FILES:
************
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'
    F.CUSTOMER.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.PASS.NAT,F.CUSTOMER.PASS.NAT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    Y.ERR.AC = ""
    R.ACCOUNT = ""

    Y.ERR.CUS = ""
    R.CUSTOMER = ""

    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""
    Y.LOG = ""
    Y.CONTADOR = 1

RETURN

PROCESS:
********

    Y.ACCOUNT.NO = R.NEW(FT.CREDIT.ACCT.NO)
    Y.TOTAL.AMT  = R.NEW(FT.CREDIT.AMOUNT)
    Y.TXN.DATE   = R.NEW(FT.PROCESSING.DATE)
    Y.ORIG.NAME  = R.NEW(FT.PAYMENT.DETAILS)

    Y.ACH.CUS.ID = ""

    GOSUB GET.CUSTOMER.ID
*****

    IF Y.ACH.CUS.ID EQ '' THEN
        ETEXT = "ACH - ID INVALIDO"
        CALL STORE.END.ERROR
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)
    Y.CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
    Y.REL.CONT = DCOUNT(R.ACCOUNT<AC.JOINT.HOLDER>,@VM)

    IF Y.CUSTOMER.NO THEN

        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
        YCUS.LEGAL = R.CUSTOMER<EB.CUS.LEGAL.ID,1>

*ESTA FUNCION DEVULEVE LA IDENTIFICACION DEL CLIENTE SEA CUAL SEA.
        CALL APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);* R22 Manual conversion
        Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

*---------------------------GDC-314---------------------------------------
*Y.ACH.CUS.ID = PARTICIP.ID de la tabla FBNK.REDO.ACH.PROCESS.DET
*Y.CUS.ID = CustomerID de la tabla CUSTOMER, estraido de la tabla ACCOUNT
*--------------------------------------------------------------------------

        Y.APPLICATION = 'CUSTOMER'
        Y.FIELDS = 'L.CU.PASS.NAT'

        CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.FIELD.POS)
        L.CU.PASS.NAT.POS = Y.FIELD.POS<1,1>
        YCUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASS.NAT.POS>

*Si posee pasaporte realizar las validaciones correspondientes
*Sino es passaporte

        IF YCUS.FOREIGN THEN
            GOSUB VALIDAR.CUS.PASAPORTE
        END ELSE
            GOSUB VALIDAR.CUS.CEDULA.RNC
        END

    END ELSE

        ETEXT = "ACH - ID INVALIDO"
        CALL STORE.END.ERROR

    END

RETURN

VALIDAR.CUS.CEDULA.RNC:
**********************

    IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
        RETURN
    END ELSE

        IF Y.REL.CONT EQ 0 OR Y.REL.CONT EQ '' THEN

            ETEXT = "ACH - ID INVALIDO"
            CALL STORE.END.ERROR

        END ELSE

*Si la transferencia no fue realizada por el dueno de la cuenta, verifica si es una cliente relacionado.

            FOR A = 1 TO Y.REL.CONT STEP 1

                Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,A>
                Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,A>

                IF Y.RELATION.CODE EQ 500 OR Y.RELATION.CODE EQ 501 OR Y.RELATION.CODE EQ 510 THEN

                    CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
                    CALL APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);* R22 Manual conversion - CALL method format changed
                    Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

                    IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
                        RETURN
                    END ELSE
                        ETEXT = "ACH - ID INVALIDO"
                        CALL STORE.END.ERROR
                    END

                END ELSE
                    ETEXT = "ACH - ID INVALIDO"
                    CALL STORE.END.ERROR
                END

            NEXT A

        END
    END
RETURN

VALIDAR.CUS.PASAPORTE:
*********************

    IF Y.ACH.CUS.ID EQ YCUS.LEGAL OR Y.ACH.CUS.ID EQ Y.CUS.ID THEN
        RETURN
    END ELSE

        IF Y.REL.CONT EQ 0 OR Y.REL.CONT EQ '' THEN

            ETEXT = "ACH - ID INVALIDO"
            CALL STORE.END.ERROR

        END ELSE

*Si la transferencia no fue realizada por el dueno de la cuenta, verifica si es una cliente relacionado.
            FOR A = 1 TO Y.REL.CONT STEP 1

                Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,A>
                Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,A>

                IF Y.RELATION.CODE EQ 500 OR Y.RELATION.CODE EQ 501 OR Y.RELATION.CODE EQ 510 THEN

                    CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
                    CALL APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);* R22 Manual conversion
                    Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

                    IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
                        RETURN
                    END ELSE
                        ETEXT = "ACH - ID INVALIDO"
                        CALL STORE.END.ERROR
                    END

                END ELSE
                    ETEXT = "ACH - ID INVALIDO"
                    CALL STORE.END.ERROR
                END

            NEXT A

        END
    END
RETURN


GET.CUSTOMER.ID:
************

    SEL.CMD = "SELECT ": FN.REDO.ACH.PROCESS.DET: " WITH ACCOUNT EQ '": Y.ACCOUNT.NO: "' AND TXN.AMOUNT EQ " :Y.TOTAL.AMT: " AND ORIGINATOR.NAME EQ '" : Y.ORIG.NAME : "' AND @ID LIKE ": Y.TXN.DATE: "... BY-DSND DATE.TIME"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    IF NO.OF.REC EQ 0 OR NO.OF.REC EQ '' THEN
        SEL.LIST = ""
        NO.OF.REC = ""
        SEL.ERR = ""

        Y.ORIG.NAME.SHORT = SUBSTRINGS(Y.ORIG.NAME, 1, 3)
        SEL.CMD = "SELECT ": FN.REDO.ACH.PROCESS.DET: " WITH ACCOUNT EQ '": Y.ACCOUNT.NO: "' AND TXN.AMOUNT EQ " :Y.TOTAL.AMT: " AND ORIGINATOR.NAME LIKE '" : Y.ORIG.NAME.SHORT : "...' AND @ID LIKE ": Y.TXN.DATE: "... BY-DSND DATE.TIME"
        CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    END

    LOOP
        REMOVE Y.ACH.DET.ID FROM SEL.LIST SETTING ACH.DET.POS
    WHILE Y.ACH.DET.ID DO

        CALL F.READ(FN.REDO.ACH.PROCESS.DET, Y.ACH.DET.ID, R.REDO.ACH.PROCESS.DET, F.REDO.ACH.PROCESS.DET, ACH.DET.ERR)

        Y.ACH.CUS.ID = ""
        Y.ACH.CUS.ID = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.PARTICIP.ID>
        Y.ACH.CUS.ID = EREPLACE(Y.ACH.CUS.ID, "-", "")

        RETURN
* RETORNAMOS EL ID DEL ULTIMO REGISTRO INSERTADO PARA LAS CONDICIONES INDICADAS SEGUN EL ORDEN DESCENDIENTE DE LA CONSULTA.

    REPEAT

RETURN

END
