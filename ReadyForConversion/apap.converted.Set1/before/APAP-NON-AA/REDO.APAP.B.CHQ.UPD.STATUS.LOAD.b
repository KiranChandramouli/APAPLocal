*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.B.CHQ.UPD.STATUS.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.CHQ.UPD.STATUS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : This is an MULTI-THREAD LOAD routine, this routine will initialise the file
*                    variables and open/read and load the file variables with return values
*Linked With       : Batch REDO.APAP.B.CHQ.UPD.STATUS
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : REDO.APAP.H.PARAMETER               As          I       Mode
*                    REDO.APAP.LOAN.CHEQUE.DETAILS       As          I-o     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                Description
*   ------            -----               -------------             -------------
* 10 Jun 2010     Shiva Prasad Y      ODR-2009-10-1678 B.10        Initial Creation
* 09-Dec-2010   Krishna Murthy T.S   TAM-ODR-2009-10-1678(B.10)    ModifiED. Opening the table REDO.LOAN.CHQ.RETURN
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.H.PARAMETER
$INSERT I_F.REDO.APAP.LOAN.CHEQUE.DETAILS
$INSERT I_REDO.APAP.B.CHQ.UPD.STATUS.COMMON
$INSERT I_F.REDO.LOAN.CHQ.RETURN
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.REDO.APAP.H.PARAMETER  = 'F.REDO.APAP.H.PARAMETER'
  F.REDO.APAP.H.PARAMETER   = ''
  CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

  FN.REDO.APAP.LOAN.CHEQUE.DETAILS = 'F.REDO.APAP.LOAN.CHEQUE.DETAILS'
  F.REDO.APAP.LOAN.CHEQUE.DETAILS  = ''
  CALL OPF(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,F.REDO.APAP.LOAN.CHEQUE.DETAILS)

*ODR2009101678-START.1

  FN.REDO.LOAN.CHQ.RETURN = 'F.REDO.LOAN.CHQ.RETURN'
  F.REDO.LOAN.CHQ.RETURN = ''
  CALL OPF(FN.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN)

*ODR2009101678-END.1

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  REDO.APAP.H.PARAMETER.ID = 'SYSTEM'
  GOSUB READ.REDO.APAP.H.PARAMETER

  RETURN
*--------------------------------------------------------------------------------------------------------
***************************
READ.REDO.APAP.H.PARAMETER:
***************************
* In this para of the code, file REDO.APAP.H.PARAMETER is read

  R.REDO.APAP.H.PARAMETER  = ''
  REDO.APAP.H.PARAMETER.ER = ''
  CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,REDO.APAP.H.PARAMETER.ID,R.REDO.APAP.H.PARAMETER,REDO.APAP.H.PARAMETER.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
END
