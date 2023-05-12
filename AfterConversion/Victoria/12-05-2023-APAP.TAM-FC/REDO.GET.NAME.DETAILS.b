* @ValidationCode : MjotMTI3MzY0MDU2ODpDcDEyNTI6MTY4MTIwNzY3MDYxNjpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:37:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.NAME.DETAILS(Y.FINAL.NAME)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.NAME.DETAILS
* ODR NUMBER    : PACS00099482
*--------------------------------------------------------------------------------------
* Description   : This routine attached with VERSION.CONTROL>AZ.ACCOUNT as a input routine to check some conditions.
* In parameter  : none
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 05-08-2011      MARIMUTHU S     PACS00099482                      Initial creation
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - CALL ROUTINE ADDED
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.UPDATE.CUS.AC
    $USING APAP.REDORETAIL
****
MAIN:
****
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

OPENFILES:
*---------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.TEMP.UPDATE.CUS.AC = 'F.REDO.TEMP.UPDATE.CUS.AC'
    F.REDO.TEMP.UPDATE.CUS.AC = ''
    CALL OPF(FN.REDO.TEMP.UPDATE.CUS.AC,F.REDO.TEMP.UPDATE.CUS.AC)

RETURN

PROCESS:

    APPLNS = 'CUSTOMER':@FM:'FUNDS.TRANSFER'
    LRT.FIELDS = 'L.CU.TIPO.CL':@FM:'BENEFIC.NAME'
    LRT.POS = ''
    CALL MULTI.GET.LOC.REF(APPLNS,LRT.FIELDS,LRT.POS)
    Y.TIPO.POS = LRT.POS<1,1>
    POS.FT.BENEF.NAME = LRT.POS<2,1>

    Y.CHEQUE.NO = R.NEW(FT.CREDIT.THEIR.REF)
    Y.CUST.ID = R.NEW(FT.ORDERING.CUST)
    CALL F.READ(FN.REDO.TEMP.UPDATE.CUS.AC,Y.CUST.ID,R.TEMP.REC,F.REDO.TEMP.UPDATE.CUS.AC,ERR.TEMP)
    Y.ACCT.NO = R.TEMP.REC<REDO.RG.AC.ID,1>

    GOSUB DIRECCION

RETURN
****************
ADDRESS.PROCESS:
****************
    Y.CNT.ADDR.LINE = DCOUNT(Y.ADDRESS.DET,@FM)
    Y.LINE.ADDR.CNT = 1
    LOOP
    WHILE Y.LINE.ADDR.CNT LE Y.CNT.ADDR.LINE

        Y.ADDR.LINE = TRIM(Y.ADDRESS.DET<Y.LINE.ADDR.CNT>, "", "D")
        IF Y.ADDR.LINE THEN
            Y.FINAL.NAME :=@VM:SPACE(18):Y.ADDR.LINE
        END
        Y.LINE.ADDR.CNT += 1 ;* R22 Auto conversion
    REPEAT

RETURN
**********
DIRECCION:
**********
    Y.FULL.NAME = R.NEW(FT.LOCAL.REF)<1,POS.FT.BENEF.NAME,1>
    Y.LIST.NAME = R.NEW(FT.LOCAL.REF)<1,POS.FT.BENEF.NAME,2>

    IF Y.LIST.NAME THEN
        Y.FINAL.NAME = Y.FULL.NAME: ' ':Y.LIST.NAME
    END ELSE
        Y.FINAL.NAME = Y.FULL.NAME
    END

    Y.FINAL.NAME = TRIM(Y.FINAL.NAME, "", "D")
    Y.DUP.NAME.LIST = Y.FINAL.NAME
    Y.FINAL.NAME = Y.DUP.NAME.LIST
*CALL REDO.DS.AZ.MAIL.ADD(Y.ACCT.NO,Y.ADDRESS.DET)
*R22 MANUAL CONVERSION
    CALL APAP.REDORETAIL.redoDsAzMailAdd(Y.ACCT.NO,Y.ADDRESS.DET)
    GOSUB ADDRESS.PROCESS
    Y.FINAL.NAME = Y.FINAL.NAME:@VM:@VM:SPACE(18):'REF : CHEQUE NUMERO ':Y.CHEQUE.NO
    Y.DATE = TODAY
*CALL REDO.GET.DATE.INT.FORM(Y.DATE)
*R22 MANUAL CONVERSION
    CALL APAP.TAM.redoGetDateIntForm(Y.DATE)
    Y.DATES = Y.DATE[3,4]:'/':Y.DATE[8,4]

    Y.FINAL.NAME = Y.FINAL.NAME:@VM:@VM:SPACE(18):'Estimado (s) senor (es):':@VM:@VM:SPACE(18):'Anexo a la presente le remitimos el cheque de referencia por concepto de los intereses'
    Y.FINAL.NAME := @VM:SPACE(18):'devengados por su (s) certificado (s), durante el mes de ':Y.DATES:' , segun detalle:'

    Y.FINAL.NAME := @VM:@VM:SPACE(18):'--------------------------------------------------------------------------------------------------------'
    Y.FINAL.NAME := @VM:SPACE(18):'':FMT('CERTIFICADO NUMERO','L#20'):FMT('FECHA APERTURA','L#20'):FMT('MONTO DEL CERTIFICADO','L#24'):FMT('TASA DE INTERES(%)','L#20'):FMT('INTERES DEL MES','L#20')
    Y.FINAL.NAME := @VM:SPACE(18):'--------------------------------------------------------------------------------------------------------'

*CALL REDO.GET.COVER.DETAILS(Y.SEC.ARR) ;* R22 Manual Conversion
    CALL APAP.TAM.redoGetCoverDetails(Y.SEC.ARR)
    Y.FINAL.NAME := @VM:Y.SEC.ARR

    Y.FINAL.NAME := @VM:'':@VM:SPACE(18):'En cumplimiento a la ley 288-04, el valor del cheque corresponde al monto total de los Intereses, menos el'

    Y.FINAL.NAME := @VM:SPACE(18):'Impuesto correspondiente.'

    Y.FINAL.NAME := @VM:'':@VM:SPACE(18):'Le agradecemos devolvernos la copia anexa de esta comunicacion debidamente firmada en el lugar indicado.'

    Y.FINAL.NAME := @VM:'':@VM:SPACE(18):'RECIBIDO CONFORME'

    Y.FINAL.NAME := @VM:'':@VM:@VM:@VM:SPACE(18):'Firma:  ____________________ '
    Y.FINAL.NAME := @VM:@VM:@VM:SPACE(18):'Nombre: ____________________ '
    Y.FINAL.NAME := @VM:@VM:@VM:SPACE(18):'Cedula: ____________________'
    Y.FINAL.NAME := @VM:@VM:@VM:SPACE(18):'Fecha:  ____________________'


RETURN

PGM.END:

END
