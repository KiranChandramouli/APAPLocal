* @ValidationCode : MjotNzExNTEzMTQ5OkNwMTI1MjoxNzA1Mzk2NjI4OTYwOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jan 2024 14:47:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , I TO I.VAR
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*16-01-2024	       VIGNESHWARI       	ADDED COMMENT FOR INTERFACE CHANGES          SQA-12394 - By Santiago
*------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.REL.MON
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RELATION ;* AUTO R22 CODE CONVERSION END
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-START
    GOSUB INITIALIZE
    IF Y.CNT GT 0 THEN
        GOSUB PROCESS
    END ELSE
        COMI = ''
    END

RETURN

INITIALIZE:
;*Fix SQA-12394 - By Santiago-END
    Y.ACC.ID = COMI
    Y.CUS.ID = ""
    Y.RELACION.CODE = ""
    Y.JOINT.HOLDER = ""
    Y.CADENA = ""

    R.PASAPORTE = ""
    R.CEDULA = ""
    R.RNC = ""
    R.ACTA = ""
    R.NUMERO.UNICO = ""
    R.IDENTIFICACION = ""

    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED
    CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERROR)	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED

    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    CALL OPF(FN.CUS,FV.CUS)	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED

    FN.REL = "F.RELATION"
    FV.REL = ""
    CALL OPF(FN.REL,FV.REL)	;*Fix SQA-12394 - By Santiago-CHANGED "(FN.ACC,FV.ACC)" TO "(FN.REL,FV.REL)"
    
    Y.CNT = 0	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED
    Y.CANT.RELACIONES = R.ACC<AC.JOINT.HOLDER>
    Y.CNT = DCOUNT(Y.CANT.RELACIONES,@VM)
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-START    
RETURN

PROCESS:
    APP.ARR ='CUSTOMER'
    FIELD.ARR = 'L.CU.RNC':@VM:'L.CU.CIDENT':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO'
    CALL MULTI.GET.LOC.REF(APP.ARR,FIELD.ARR,POS.ARR)
    L.CU.RNC.POS    = POS.ARR<1,1>
    L.CU.CIDENT.POS = POS.ARR<1,2>
    L.CU.ACTANAC.POS= POS.ARR<1,3>
    L.CU.NOUNICO.POS= POS.ARR<1,4>
 ;*Fix SQA-12394 - By Santiago-END   
    I.VAR =1
    LOOP	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED
    WHILE I.VAR LE Y.CNT	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED
        Y.RELACION.CODE = R.ACC<AC.RELATION.CODE , I.VAR >

        Y.CUS.ID = R.ACC<AC.JOINT.HOLDER, I.VAR >
        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,FV.CUS,CUS.ERROR)

        R.PASAPORTE = R.CUS<EB.CUS.LEGAL.ID>
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-START
        R.RNC = R.CUS<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
	R.CEDULA = R.CUS<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
	R.ACTA = R.CUS<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS>
	R.NUMERO.UNICO = R.CUS<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-END

        IF R.CEDULA NE "" THEN
            R.IDENTIFICACION = R.CEDULA
        END

        IF R.RNC NE "" THEN
            R.IDENTIFICACION = R.RNC
        END

        IF R.PASAPORTE NE "" THEN
            R.IDENTIFICACION = R.PASAPORTE
        END

        IF R.ACTA NE ""  THEN
            R.IDENTIFICACION = R.ACTA
        END

        IF R.NUMERO.UNICO NE "" THEN
            R.IDENTIFICACION = R.NUMERO.UNICO
        END
        
        CALL F.READ(FN.REL,Y.RELACION.CODE,R.REL,FV.REL,REL.ERROR)

        R.DES.REL = R.REL<EB.REL.DESCRIPTION>

        IF  R.CUS<EB.CUS.NAME.1> NE "" THEN
            COMI = CADENA :  "*" : R.IDENTIFICACION : ";" : R.CUS<EB.CUS.NAME.1> : ";" : R.DES.REL
            CADENA = CADENA :  "*" : R.IDENTIFICACION : ";" : R.CUS<EB.CUS.NAME.1> : ";" : R.DES.REL
        END
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-START    
        I.VAR += 1
          
    REPEAT
RETURN
;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED-END
END
