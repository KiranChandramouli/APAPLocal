* @ValidationCode : MjotMjExNzIwMDI2NDpDcDEyNTI6MTY4MjMzNTk0MzI3MTpJVFNTOi0xOi0xOjE4MjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 182
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.TEL.SIMULACION
*--------------------------------------------------------------------------------------------------
* Description           : Rutina para obtener el telefono del cliente
*                        recibe como parametro el codigo del cliente
* Developed On          : 16-juan-2019
* Developed By          : Bienvenido Romero
* Development Reference : Para el proceso de monitor req: CI009444
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    Y.CLIENTE.ID = COMI
    Y.CLIENTE.ID = CHANGE(Y.CLIENTE.ID,"*",@FM)
    Y.CUS.ID = Y.CLIENTE.ID<1>
    Y.TIPO = Y.CLIENTE.ID<2>
    GOSUB INICIO
    GOSUB GET.TELEFONO.CLIENTE
RETURN
INICIO:
*********
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)
RETURN

GET.TELEFONO.CLIENTE:
*********************
    R.CUSTOMER = ''; ERROR.CUSTOMER = ''
    CALL F.READ(FN.CUS,Y.CUS.ID,R.CUSTOMER,F.CUS,CUS.ERR)
    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.TYPE",Y.POS)
    Y.TEL.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.POS>
    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.AREA",Y.POS)
    Y.AREA = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.POS>
    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.NO",Y.POS)
    Y.TEL.NO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.POS>
    GOSUB CONVERT.FM.CUSTOMER
    LOCATE Y.TIPO IN  Y.TEL.TYPE<1> SETTING CUS.POS THEN
        COMI = Y.AREA<CUS.POS>:Y.TEL.NO<CUS.POS>
    END ELSE
        COMI = ''
    END
RETURN
CONVERT.FM.CUSTOMER:
*******************
    Y.TEL.TYPE = CHANGE(Y.TEL.TYPE,@SM,@FM)
    Y.TEL.TYPE = CHANGE(Y.TEL.TYPE,@VM,@FM)
    Y.TEL.NO = CHANGE(Y.TEL.NO,@SM,@FM)
    Y.TEL.NO = CHANGE(Y.TEL.NO,@VM,@FM)
    Y.AREA = CHANGE(Y.AREA,@SM,@FM)
    Y.AREA = CHANGE(Y.AREA,@VM,@FM)
RETURN

END
