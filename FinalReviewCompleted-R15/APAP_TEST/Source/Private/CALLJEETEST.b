* @ValidationCode : MjotNTc1MTQ2ODM5OkNwMTI1MjoxNjgxOTcwMDcxNzM5OklUU1M6LTE6LTE6Mzk3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 11:24:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 397
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*19-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION          INCLUDE TO INSERT
*19-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*Sample Program for testing webservice using CALLJEE
*----------------------------------------------------------------------------------------
PROGRAM CALLJEETEST
*----------------------------------------------------------------------------------------
    $INSERT JBC.h ;* AUTO R22 CODE CONVERSION
    ACTIVATION = "APAP_SUNNEL_INTERFACE"       ;*Activation key mentioned in the document
    INPUT_PARAM = "BE_K_TC.BUSCAR_TARJETA_CUENTA@4794110310000491#Pv_Numero#VARCHAR2@Pv_Estado_Tarjeta#VARCHAR2~Pv_Estado_Cuenta#VARCHAR2~Pd_Fecha_Limite_Pago#DATE~Pn_Balance_al_corte_Pesos#NUMBER~Pn_Balance_al_corte_Dolares#NUMBER~Pn_Pago_minimo_pesos#NUMBER~Pn_Pago_minimo_dolares#NUMBER~Pi_Cantidad_cheques_devueltos#INTEGER~Pv_NumeroTarjeta#VARCHAR2~Pv_NumeroCuenta#VARCHAR2~Pv_NumeroDocumento#VARCHAR2~Pv_DescripcionDocumento#VARCHAR2~Pv_NombreCliente#VARCHAR2~Pi_Codigo_Cliente#INTEGER~Pi_CodigoMensaje#INTEGER~Pv_DescripcionMensaje#VARCHAR2"
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
    IF ERROR.CODE THEN
*If there is any error occurs before invoking the webservice, then the
*following block will be executed
        RETURN.VALUE = "FAIL@FM":ERROR.CODE
        CRT "Java Component Error before invoking the service " : RETURN.VALUE
    END ELSE
        CRT "Response is : " : INPUT_PARAM
    END
END
