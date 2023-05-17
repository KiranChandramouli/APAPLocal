* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DC.FTTC.SEL.ADJ(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.DC.FTTC.SEL.ADJ
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for REDO.APAP.ARC.LOAN.DETS

*Linked with   :
* In Parameter  :ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*22.11.2012     PACS00234392            Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System

  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------
  ENQ.DATA<2,1>= '@ID'
  ENQ.DATA<3,1>= 'EQ'
  ENQ.DATA<4,1> = 'AC60 AC61 AC80 AC62 AC63 AC75 AC76 AC71 AC74 AC68 AC74 ACP1'
  RETURN
END
