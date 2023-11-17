* @ValidationCode : MjotNDQzMDY5MDc6Q3AxMjUyOjE2ODE4MjgwMDYyNTc6SVRTUzotMTotMTozMzc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 337
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.REQUEST.PROCESS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Auto id routine for REDO.CARD.REQUEST,PRE.EMBOSS version, to default
*               status field to 1 if curr number equal to 1
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Jul 2010    Mohammed Anies K       ODR-2010-03-0400        Initial Creation
* 05-4-2011      KAVITHA                PACS00036008            ISSUE FIX
* 19 MAY 2011    JEEVA T                ODR-2010-03-0400        Removing Start Number Validation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.LOCKING
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.BRANCH.REQ.STOCK
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.CARD.REG.STOCK
*--------------------------------------------------------------------------------------------------------



    Y.CURR.NO = R.NEW(REDO.CARD.REQ.CURR.NO)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    Y.ID.COMP = R.NEW(REDO.CARD.REQ.AGENCY)
    CALL CACHE.READ(FN.COMPANY, Y.ID.COMP, R.COMP, Y.ERR.COMP) ;* AUTO R22 CODE CONVERSION
    R.NEW(REDO.CARD.REQ.AGENCY.DESC) = R.COMP<EB.COM.COMPANY.NAME,1>
    IF R.NEW(REDO.CARD.REQ.CURR.NO) EQ '' THEN
        GOSUB REG.STOCK
    END

RETURN
*------------------------------------------------------------------------------------
***********
REG.STOCK:
************

    FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STOCK = ''
    CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)



    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
    VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
    Y.CARD.REG.STOCK.ID = 'CARD.':FINAL.COMP:
    CALL F.READU(FN.REDO.CARD.REG.STOCK,Y.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,REDO.CARD.REG.STOCK.ERR,'')
    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.CARD.REQ.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1


    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES

        Y.CARD.SERIES.ID = R.NEW(REDO.CARD.REQ.CARD.SERIES.ID)<1,Y.INIT.COUNT>

*PACS00036008-S
*BALACOMMENTED        Y.CARD.SERIES.ID = "*":Y.CARD.SERIES.ID:"*"
*PACS00036008-E

*>>>>>>>>>>>below validation's are commented -- Jeeva >>>>>>>>>>>>>>>>>

**    LOCATE Y.CARD.SERIES.ID IN R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,1> SETTING Y.SERIES.ID.POS THEN

**        Y.SERIES.NO = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,Y.SERIES.ID.POS>
**        Y.FINAL.SERIES.NO = FIELD(Y.SERIES.NO,'-',2)
**        Y.FINAL.SERIES.NO +=1
**        IF R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> EQ '' THEN
**            R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = Y.FINAL.SERIES.NO
**        END
**    END ELSE
**        IF R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> EQ '' THEN
**            R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = 1
**        END
**    END


*        IF Y.CARD.SERIES.ID NE '' THEN
*           LOCATE Y.CARD.SERIES.ID IN R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,1> SETTING Y.SERIES.ID.POS THEN
*              Y.SERIES.NO = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,Y.SERIES.ID.POS>
* Y.SECOND.SERIES = FIELD(Y.SERIES.NO,'-',2)
* Y.FINAL.SERIES.NO = FIELD(Y.SERIES.NO,'-',1) + R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY)<1,Y.INIT.COUNT>

*       Y.FINAL.SERIES.NO = FIELD(Y.SERIES.NO,'-',2)

*      Y.SECOND.SERIES=Y.FINAL.SERIES.NO + R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY)<1,Y.INIT.COUNT>

*     Y.FIRST.SERIES.NO=FIELD(Y.SERIES.NO,'-',1)
*    Y.FINAL.SERIES.NO +=1

*   R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = Y.FINAL.SERIES.NO


*               IF Y.FINAL.SERIES.NO GT Y.SECOND.SERIES THEN
*                    ETEXT = "AC-QUANTITY.NOT.AVAILABLE.STOCK.REGISTER"
*                  CALL STORE.END.ERROR
*             END

*       R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,Y.SERIES.ID.POS> = Y.FIRST.SERIES.NO:'-':Y.SECOND.SERIES
*                CALL F.WRITE(FN.REDO.CARD.REG.STOCK,Y.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK)

*  END ELSE
*    ETEXT = "EB-VIRGIN.ENTRY"
*   CALL STORE.END.ERROR

*  END ELSE

*     R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = 1

*    Y.FINAL.SERIES.NO=1
*   Y.SECOND.SERIES=R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY)<1,Y.INIT.COUNT>

*       R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,Y.SERIES.ID.POS>=Y.CARD.SERIES.ID
*      R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,Y.SERIES.ID.POS> = Y.FINAL.SERIES.NO:'-':Y.SECOND.SERIES


* END
*   END
        Y.INIT.COUNT +=1
    REPEAT
*
*   IF R.REDO.CARD.REG.STOCK NE '' THEN
*     CALL F.WRITE(FN.REDO.CARD.REG.STOCK,Y.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK)
*  END
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Ends>>>>>>>>>>>>>>>>>>>>

RETURN
*-------------------------------------------------------------------------------------------------------
END
