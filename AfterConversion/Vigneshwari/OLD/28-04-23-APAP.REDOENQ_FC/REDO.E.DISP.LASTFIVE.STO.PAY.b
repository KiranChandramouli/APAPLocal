* @ValidationCode : MjoyNDc2MTQ3NTI6Q3AxMjUyOjE2ODIwNzg4NzE1NTA6SVRTUzotMTotMToxODA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 180
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.DISP.LASTFIVE.STO.PAY(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00112995          Prabhu N                MODIFICAION
*19/09/11      PACS00125978          PRABHUN                 MODIFICATION
*
* 18-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, ++ to +=, if condition added
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB INITIALISE
    GOSUB GET.STO.DETAILS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    STO.WRK.ID=''
    CUSTOMER.ID = System.getVariable("EXT.CUSTOMER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        CUSTOMER.ID = ""
    END					;*R22 Auto conversion - end
    STO.WRK.ID = CUSTOMER.ID:"-":"P"

    FN.REDO.STO='F.REDO.STO.STORE.LASTFIVE'
    F.REDO.STO=''
    CALL OPF(FN.REDO.STO,F.REDO.STO)
    Y.STMT.ID.LIST=''

    DISP.CNT=1
    MAX.DISP.CNT=5

RETURN
*----------------------------------------------------------------------------
GET.STO.DETAILS:
*-----------------------------------------------------------------------------
*PACS00125978-S

    CALL F.READ(FN.REDO.STO,STO.WRK.ID,R.REDO.STO.REC,F.REDO.STO,STO.ERR)
    IF NOT(STO.ERR) THEN
        LOOP
        WHILE DISP.CNT LE MAX.DISP.CNT
            Y.STMT.ID.LIST<-1> = R.REDO.STO.REC<DISP.CNT>
            DISP.CNT += 1
        REPEAT

        CHANGE @FM TO ' ' IN Y.STMT.ID.LIST
        ENQ.DATA<2,1>='@ID'
        ENQ.DATA<3,1>='EQ'
        ENQ.DATA<4,1>=Y.STMT.ID.LIST

    END ELSE
        ENQ.DATA<2,1>='@ID'
        ENQ.DATA<3,1>='EQ'
        ENQ.DATA<4,1>=''

    END
RETURN
*PACS00125978-E
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
