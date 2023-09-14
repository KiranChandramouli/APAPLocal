* @ValidationCode : MjoxMzM5NzM0ODc6Q3AxMjUyOjE2ODI0MjA3NTgwODg6MzMzc3U6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:35:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.CLR.FIELDS
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-03-07
* Description  : This routine will clear all information stored on fields that used for B02 in case of Policy Type or Class Policy Has benn changed
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2012-03-07    Jorge Valarezo   First Version
* 1.1              2012-03-07    Jorge Valarezo   Add new field to deleted
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, -- TO -=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*==================
INITIALISE:
*==================
    CAMPO.ACTUAL  = OFS$HOT.FIELD
    NOMBRE.CAMPO  = "INS.POLICY.TYPE"
    NOMBRE.CAMPO1 = "CLASS.POLICY"
    Y.FIELD.POS = DCOUNT ( R.GTS,@FM )
    Y.FIELD.SEARCH = ''
    NUM.LENGTH    = DCOUNT (CAMPO.ACTUAL,".")
    POS.VM        = 1

    IF NUM.LENGTH EQ 4 THEN
        POS.VM = FIELD (CAMPO.ACTUAL,".",4,4)
        CAMPO.ACTUAL = FIELD (CAMPO.ACTUAL,".",1,3)
    END
    IF NUM.LENGTH EQ 3 THEN
        POS.VM = FIELD (CAMPO.ACTUAL,".",3,3)
        CAMPO.ACTUAL = FIELD (CAMPO.ACTUAL,".",1,2)
    END

RETURN

*==================
OPENFILES:
*==================
RETURN


*==================
PROCESS:
*==================


    IF CAMPO.ACTUAL NE NOMBRE.CAMPO AND CAMPO.ACTUAL NE NOMBRE.CAMPO1 THEN
        RETURN
    END
    IF R.NEW(REDO.FC.INS.MANAGEM.TYPE)<1,POS.VM> EQ "NO INCLUIR EN CUOTA" AND R.NEW(REDO.FC.INS.PRI.PROPER) NE "" AND R.NEW(REDO.FC.INS.XPRI.PROPER) NE "" THEN
        TEXT = 'EB.FC.PROP.DES':@FM:R.NEW(REDO.FC.INS.PRI.PROPER):@FM:R.NEW(REDO.FC.INS.XPRI.PROPER)
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)

    END


    R.NEW(REDO.FC.INS.MANAGEM.TYPE)<1,POS.VM>    = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.MANAGEM.TYPE
    R.NEW(REDO.FC.INS.AMOUNT)<1,POS.VM>          = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.AMOUNT
    R.NEW(REDO.FC.DATE.AMT.SEC)<1,POS.VM>        = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.DATE.AMT.SEC
    R.NEW(REDO.FC.INS.MON.POL.AMT)<1,POS.VM>     = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.MON.POL.AMT
    R.NEW(REDO.FC.INS.PRI.PROPER)<1,POS.VM>      = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.PRI.PROPER
    R.NEW(REDO.FC.INS.EXTRA.AMT)<1,POS.VM>       = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.EXTRA.AMT
    R.NEW(REDO.FC.INS.XPRI.PROPER)<1,POS.VM>     = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.XPRI.PROPER
    R.NEW(REDO.FC.INS.TOT.PREM.AMT)<1,POS.VM>    = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.TOT.PREM.AMT
    R.NEW(REDO.FC.INS.DATE.BEG.CHARG)<1,POS.VM>  = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.DATE.BEG.CHARG
    R.NEW(REDO.FC.INS.DATE.END.CHARG)<1,POS.VM>  = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.DATE.END.CHARG
    R.NEW(REDO.FC.INS.TOTAL.PREM.AMT)<1,POS.VM>  = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.TOTAL.PREM.AMT
    R.NEW(REDO.FC.INS.POLI.ORG.DATE)<1,POS.VM>   = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.POLI.ORG.DATE
    R.NEW(REDO.FC.INS.POL.START.DATE)<1,POS.VM>  = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.POL.START.DATE
    R.NEW(REDO.FC.INS.POL.EXP.DATE)<1,POS.VM>    = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.POL.EXP.DATE
    R.NEW(REDO.FC.INS.SEC.COM.TYPE)<1,POS.VM>    = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.SEC.COM.TYPE
    R.NEW(REDO.FC.INS.SEC.COM.AMT)<1,POS.VM>     = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.SEC.COM.AMT
    R.NEW(REDO.FC.TAX.MANAGEM.TYPE)<1,POS.VM>    = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.TAX.MANAGEM.TYPE
    R.NEW(REDO.FC.DATE.BEG.CHARG)<1,POS.VM>      = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.DATE.BEG.CHARG
    R.NEW(REDO.FC.DATE.END.CHARG)<1,POS.VM>      = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.DATE.END.CHARG
    R.NEW(REDO.FC.INS.PAY.TYPE)<1,POS.VM>      = ""
    Y.FIELD.SEARCH<-1> = REDO.FC.INS.PAY.TYPE
*ADDED TO DELETE INFORMATION STORED IN PAYMENT SCHEDULE ID CLASS OR TYPOLICY HAS BEEN CHANGED
*JV16MAR2012
    R.NEW(REDO.FC.PAYMENT.TYPE) = ''
    R.NEW(REDO.FC.PAYMENT.METHOD)= ''
    R.NEW(REDO.FC.PAYMENT.FREQ) = ''
    R.NEW(REDO.FC.PROPERTY) = ''
    R.NEW (REDO.FC.DUE.FREQ) = ''
    R.NEW(REDO.FC.PERCENTAGE) = ''
    R.NEW(REDO.FC.START.DATE) = ''
    R.NEW(REDO.FC.END.DATE) = ''
    R.NEW(REDO.FC.NUM.PAYMENTS) = ''
    R.NEW(REDO.FC.CALC.AMOUNT) = ''
    R.NEW(REDO.FC.ACTUAL.AMT) = ''
    R.NEW(REDO.FC.AMORTISATION.TERM) = ''
    R.NEW(REDO.FC.RESIDUAL.AMOUNT) = ''
*JV16MAR2012
    LOOP
    WHILE Y.FIELD.POS GE 1

        LOCATE R.GTS<Y.FIELD.POS,3> IN Y.FIELD.SEARCH<1> SETTING Y.POS THEN
            DEL R.GTS<Y.FIELD.POS>
            Y.FIELD.POS -= 1 ;*AUTO R22 CODE CONVERSION
        END
        ELSE
            Y.FIELD.POS -= 1
        END

    REPEAT

RETURN

END
